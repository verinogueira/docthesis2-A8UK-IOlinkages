%% UK, YEAR 2003, 29 INDUSTRIES
%clear everything
clear
close all
clc

%control parameters
%T = 2; %years of data
N = 29; %no industries

%% OBS - DATA OBSERVED and ADJUSTED

% Factors: k, l and h (KLEMS data UK)
%capital
k_obs = readmatrix('Data_GBR_2003.xls','Sheet','pri_qua','Range','F2:F30');
%total labour employed
e_obs = readmatrix('Data_GBR_2003.xls','Sheet','pri_qua','Range','H2:H30');
%low skill
l_shr = readmatrix('Data_GBR_2003.xls','Sheet','pri_qua','Range','I2:I30');
l_obs = l_shr.*e_obs;
%high skill
h_shr = readmatrix('Data_GBR_2003.xls','Sheet','pri_qua','Range','J2:J30');
h_obs = h_shr.*e_obs;

% factor supplies
K_obs = sum(k_obs);
L_obs = sum(l_obs);
H_obs = sum(h_obs);

% total payment to factors (SEA + Klems data UK)
PAY_K = 648438.735473633;
PAY_L = 660365.523692328;
PAY_H = 518517.826161188;

% wages (average payment to factors) (SEA + Klems data UK)
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

% output (millions of US$, current prices)
pq_obs = VAi_obs;

% final consumption (millions of US$, current prices)
py_obs = pq_obs;

% % % some derivations and tests % % % 
% aggregate final consumption
PY_obs = sum(py_obs);
if abs(VA_obs - PY_obs) > 1e-9       % error: 4.6566e-10
    disp('check VA and PY')
end


% PARAMETERS 

% beta: final consumption shares on Y (sum to one)
beta = py_obs / PY_obs;

% mu: output shares on Y (sum greater than one)
mu = pq_obs / PY_obs;


% aggregate factors shares (UK data on compensation)
alpha = wK_obs*K_obs/PY_obs;
delta = wL_obs*L_obs/PY_obs;

if abs((1-alpha-delta)-wH_obs*H_obs/PY_obs) >= 1e-15
    disp('check agg factors shares')    % error:  3.3307e-16
end

% industry-specific factor shares 
alphai = (wK_obs*k_obs)./(pq_obs); 
deltai = (wL_obs*l_obs)./(pq_obs);
if max(abs((1-alphai-deltai)-wH_obs*h_obs./VAi_obs)) >= 1e-13
    disp('check agg factors shares')    % error:   1.6653e-16
end


%logs: log(X) returns the natural logarithm ln(x) of each element in array X
lbeta = log(beta);
lmu = log(mu);

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
% prices created in EXCEL so that P=1 and Cobb-Douglas aggregated is satisfied
p_data = readmatrix('Data_GBR_2003.xls','Sheet','pri_qua','Range','D2:D30');

% real values and agg prices that would be generated with data prices
y_data = py_obs./p_data;
Y_data_agg = prod(y_data.^beta);
P_data = PY_obs./Y_data_agg;

%normalising prices to P=1
p_obs = p_data/P_data;
y_obs = py_obs./p_obs;
Y_obs = prod(y_obs.^beta); % REAL OUTPUT: Cobb-Douglas aggregator final good

P_obs = PY_obs./Y_obs;
if abs(P_obs - 1) >= 1e-14         % error = 1.9984e-15
    disp('P not equal to 1')
end

% logs
lp_obs = log(p_obs);

% other REAL VARIABLES
q_obs = pq_obs./p_obs;

% logs
lq_obs = log(q_obs);
ly_obs = log(y_obs);



% backing out productivity
% sum(Gamma.*ld_obs,1): sum over rows, same column / (1X3)
lA = lq_obs - (alphai.*lki_obs + deltai.*lli_obs + (1-alphai-deltai).*lhi_obs);

A = exp(lA);

% ALL VARIABLES ARE IN VECTORS (29 X 1)%

save('Parameters2003noIO.mat','beta','mu','alpha','delta','alphai','deltai','A')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ANALYSIS

industry = (1:N)';

%% Export calculated data
 CC = table(industry,alphai,deltai,h_shares,mu,beta,k_obs,l_obs,h_obs,p_data,q_obs,y_obs);
 filename = 'Calculated_UK_2003_noIO.xls';
 writetable(CC,filename,'Sheet',1,'Range','B2')
 
 AUX = table(alpha,delta,Y_obs,wK_obs,wL_obs,wH_obs);
 writetable(AUX,filename,'Sheet',2,'Range','B2')

