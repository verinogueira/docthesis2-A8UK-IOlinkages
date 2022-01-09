%% UK, YEAR 2014, 29 INDUSTRIES
% constructs the baseline dataset

% clear everything
clear
close all
clc

% control parameters
N = 29; % number of industries

%% OBS - DATA OBSERVED and ADJUSTED

% Factors: k, l and h (KLEMS data UK)
%capital
k_obs = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','F2:F30');
k_obs(29) = 0.1; % zero has to be replaced by near zero
%total labour employed
e_obs = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','H2:H30');
%low skill
l_shr = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','B2:B30');
l_obs = l_shr.*e_obs;
%high skill
h_shr = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','C2:C30');
h_obs = h_shr.*e_obs;

% factor supplies
K_obs = sum(k_obs);
L_obs = sum(l_obs);
H_obs = sum(h_obs);

% total payment to factors (SEA + Klems data UK)
PAY_K = 919574.162086487; % sum of column G
PAY_L = 983803.06777958; % sum of column I times cell A2 sheet 'LH_shares'
PAY_H = 772480.406341514; % sum of column I times cell B2 sheet 'LH_shares'

% wages (average payment to factors) 
wK_obs = PAY_K/K_obs;
wL_obs = PAY_L/L_obs;
wH_obs = PAY_H/H_obs;

% payments to factors in each industry
pay_ki = wK_obs*k_obs;
pay_li = wL_obs*l_obs;
pay_hi = wH_obs*h_obs;

% value added in each industry
VAi_obs = pay_ki + pay_li + pay_hi;

% adjusted aggregate VA (millions of US$, current prices)
VA_obs = sum(VAi_obs);

% intermediate use 
%d matrix, where d(j,i) is usage by industry i of
% industry j's good (row is origin, column is destination)
pd_obs = readmatrix('Data_GBR_2014.xls','Sheet','IO','Range','B2:AD30');

ii_cons = sum(pd_obs)';
ii_prod = sum(pd_obs,2);


% output (millions of US$, current prices)
pq_obs = VAi_obs + ii_cons;

% final consumption (millions of US$, current prices)
py_obs = pq_obs - ii_prod;


% % % some derivations and tests % % % 
% aggregate final consumption
PY_obs = sum(py_obs);
if abs(VA_obs - PY_obs) > 1e-9       
    disp('check VA and PY')
end


% PARAMETERS 

% beta: final consumption shares on Y (sum to one)
beta = py_obs / PY_obs;

% mu: output shares on Y (sum greater than one)
mu = pq_obs / PY_obs;

%Gamma matrix, where gamma(j,i) is usage by industry i of
%industry j's good (row is origin, column is destination)
Gamma = pd_obs./pq_obs';

% gammai = sum(Gamma,1) is total intermediate share of sector i
gammai = sum(Gamma,1)';


% % % tests % % % 
% mu must satisfy mu = [I - Gamma']^(-1)*beta
mu_test = (eye(N) - Gamma)\beta;
if abs(sum(mu - mu_test)) >= 1e-15  
    disp('check parameters')
end

% condition (18) draft_20190401
CY = sum(mu.*(1-gammai));
if abs(CY - 1) >= 1e-15      
    disp('check parameters')
end



% aggregate factors shares (UK data on compensation)
alpha = wK_obs*K_obs/PY_obs;
delta = wL_obs*L_obs/PY_obs;

if abs((1-alpha-delta)-wH_obs*H_obs/PY_obs) >= 1e-15
    disp('check agg factors shares')    % error:  5.5511e-17
end

% industry-specific factor shares 
alphai = (wK_obs*k_obs)./(pq_obs.*(1-gammai)); 
deltai = (wL_obs*l_obs)./(pq_obs.*(1-gammai));
if max(abs((1-alphai-deltai)-wH_obs*h_obs./VAi_obs)) >= 1e-13
    disp('check agg factors shares')    
end


% logs: log(X) returns the natural logarithm ln(x) of each element in array X
lbeta = log(beta);
lmu = log(mu);
lGamma = log(Gamma);
lgammai = log(gammai);

lalpha = log(alpha);
ldelta = log(delta);

lalphai = log(alphai);
ldeltai = log(deltai);

lki_obs = log(k_obs);
lli_obs = log(l_obs);
lhi_obs = log(h_obs);

lK_obs = log(K_obs);
lL_obs = log(L_obs);
lH_obs = log(H_obs);



% PRICES
p_data = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','E2:E30');

% real values and agg prices that would be generated with data prices
y_data = py_obs./p_data;
Y_data_agg = prod(y_data.^beta);
P_data = PY_obs./Y_data_agg;

% normalising prices to P=1
p_obs = p_data/P_data;
y_obs = py_obs./p_obs;
Y_obs = prod(y_obs.^beta); % REAL OUTPUT: Cobb-Douglas aggregator final good

P_obs = PY_obs./Y_obs;
if abs(P_obs - 1) >= 1e-14       
    disp('P not equal to 1')
end


% logs
lp_obs = log(p_obs);


% other REAL VARIABLES
q_obs = pq_obs./p_obs;
d_obs = pd_obs./p_obs;


% logs
lq_obs = log(q_obs);
ld_obs = log(d_obs);
ly_obs = log(y_obs);



% backing out productivity
% sum(Gamma.*ld_obs,1): sum over rows, same column / (1X3)
lA = lq_obs - (1-gammai).*(alphai.*lki_obs + deltai.*lli_obs + (1-alphai-deltai).*lhi_obs) - sum(Gamma.*ld_obs,1)';

A = exp(lA);


%% GENERATE DATA FOR OTHER FILES
% save data file
save('OBS2014.mat')

% VARIABLES ARE IN VECTORS (29 X 1) %
