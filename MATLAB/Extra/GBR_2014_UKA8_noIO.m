%% MODEL WITHOUT IO
%counterfactual to high-skilled and low-skilled A8 below

% UK, YEAR 2014, 29 INDUSTRIES
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
k_obs = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','F2:F30');
%total labour employed
e_obs = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','H2:H30');
%low skill
l_shr = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','I2:I30');
l_obs = l_shr.*e_obs;
%high skill
h_shr = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','J2:J30');
h_obs = h_shr.*e_obs;

% factor supplies
K_obs = sum(k_obs);
L_obs = sum(l_obs);
H_obs = sum(h_obs);

% total payment to factors (SEA + Klems data UK)
PAY_K = 919574.162086487;
PAY_L = 983803.06777958;
PAY_H = 772480.406341514;

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
if abs(VA_obs - PY_obs) > 1e-9       % error: 0
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
    disp('check agg factors shares')    % error:  1.6653e-16
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
p_data = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','D2:D30');

% real values and agg prices that would be generated with data prices
y_data = py_obs./p_data;
Y_data_agg = prod(y_data.^beta);
P_data = PY_obs./Y_data_agg;

%normalising prices to P=1
p_obs = p_data/P_data;
y_obs = py_obs./p_obs;
Y_obs = prod(y_obs.^beta); % REAL OUTPUT: Cobb-Douglas aggregator final good

P_obs = PY_obs./Y_obs;
if abs(P_obs - 1) >= 1e-14       % error = 1.5543e-15
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ANALYSIS

% high-skill industries shares
h_shares = [(1-alphai-deltai)];

industry = (1:N)';

%% Export calculated data
%  CC = table(industry,alphai,deltai,h_shares,mu,beta,k_obs,l_obs,h_obs,p_data,q_obs,y_obs);
%  filename = 'Calculated_UK_2014_noIO.xls';
%  writetable(CC,filename,'Sheet',1,'Range','B2')
%  
%  AUX = table(alpha,delta,Y_obs,wK_obs,wL_obs,wH_obs);
%  writetable(AUX,filename,'Sheet',2,'Range','B2')

 % % already done in high-skilled .m file
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COUNTERFACTUAL: removing A8 immigrants to high-skilled labour supply 

%List of things changed in the counterfactual:
K_cf = K_obs;
L_cf = L_obs*0.968536647669954;
H_cf = H_obs*0.977848087622435;

lK_cf = log(K_cf);
lL_cf = log(L_cf);
lH_cf = log(H_cf);


%1) solve for prices and Y
lY_cf = alpha*(lK_cf-lalpha) + delta*(lL_cf-ldelta) + (1-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*alphai.*lalphai) + sum(mu.*deltai.*ldeltai) + ... 
    sum(mu.*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*lA) + sum(beta.*lbeta);
Y_cf = exp(lY_cf);

lwL_cf = alpha*(lK_cf-lalpha) - (1-delta)*(lL_cf-ldelta) + (1-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*alphai.*lalphai) + sum(mu.*deltai.*ldeltai) + ... 
    sum(mu.*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*lA) + sum(beta.*lbeta);
wL_cf = exp(lwL_cf);

lwH_cf = alpha*(lK_cf-lalpha) + delta*(lL_cf-ldelta) + (-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*alphai.*lalphai) + sum(mu.*deltai.*ldeltai) + ... 
    sum(mu.*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*lA) + sum(beta.*lbeta);
wH_cf = exp(lwH_cf);

lwK_cf = (alpha-1)*(lK_cf-lalpha) + delta*(lL_cf-ldelta) + (1-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*alphai.*lalphai) + sum(mu.*deltai.*ldeltai) + ... 
    sum(mu.*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*lA) + sum(beta.*lbeta);
wK_cf = exp(lwK_cf);

%2) solve for quantities and factor usage of each industry
lki_cf = log(alphai) + log(mu) + lY_cf - lwK_cf;
lli_cf = log(deltai) + log(mu) + lY_cf - lwL_cf;
lhi_cf = log(1-alphai-deltai) + log(mu) + lY_cf - lwH_cf;

ki_cf = exp(lki_cf);
li_cf = exp(lli_cf);
hi_cf = exp(lhi_cf);


% DISCUSSION %
% test: should be zero
test_K = sum(ki_cf) - K_cf;
test_L = sum(li_cf) - L_cf;
test_H = sum(hi_cf) - H_cf;
if test_K >= 1e-07 | test_L >= 1e-09 | test_H >= 1e-10
    disp('check K, L, H')  
end


% q 
lq_cf = lA + lmu + alphai.*(lK_cf+lalphai-lalpha) + deltai.*(lL_cf+ldeltai-ldelta) + ...
    (1-alphai-deltai).*(lH_cf+log(1-alphai-deltai)-log(1-alpha-delta));
q_cf = exp(lq_cf);

% test
lq_cf2 = lA + lmu + lY_cf + alphai.*(lalphai-lwK_cf) + deltai.*(ldeltai-lwL_cf) + ...
    (1-alphai-deltai).*(log(1-alphai-deltai)-lwH_cf);
if abs(sum(lq_cf - lq_cf2)) >= 1e-13    % error: 6.9278e-14
    disp('check V')
end



%calculate yi 
y_cf = q_cf;


Y_cf_test = prod(y_cf.^beta); % REAL OUTPUT: Cobb-Douglas aggregator final good
if abs(Y_cf_test - Y_cf) >= 1e-07          % error =  8.3819e-09
    disp('Cobb-Douglas cf dnt hold')
end


% calculate pi 
lp_cf = -lA -alphai.*(lalphai-lwK_cf) -deltai.*(ldeltai-lwL_cf) - ...
  (1-alphai-deltai).*(log(1-alphai-deltai)-lwH_cf);
p_cf = exp(lp_cf);


pq_cf = p_cf.*q_cf;
py_cf = p_cf.*y_cf;
PY_cf = sum(py_cf);


% check P=1
P_cf = PY_cf./Y_cf;
if abs(P_cf - 1) >= 1e-14          % error = 2.4425e-15
    disp('P_cf not equal to 1')
end

% check mu
mu_cf = pq_cf/Y_cf;
if max(abs(mu_cf - mu)) >= 1e-13       % error = 4.7184e-16
    disp('mu_cf not equal to 1')
end

%% Results

dYdH_cf = ((Y_cf - Y_obs)/Y_obs)*100;
dwKdH_cf = ((wK_cf - wK_obs)/wK_obs)*100;
dwLdH_cf = ((wL_cf - wL_obs)/wL_obs)*100;
dwHdH_cf = ((wH_cf - wH_obs)/wH_obs)*100;
dkidH_cf = ((ki_cf - k_obs)./k_obs)*100;
dlidH_cf = ((li_cf - l_obs)./l_obs)*100;
dhidH_cf = ((hi_cf - h_obs)./h_obs)*100;

% calculate effects on qi
dqidH_cf = ((q_cf - q_obs)./q_obs)*100;

% PRICES: calculate effects on pi
dpidH_cf = ((p_cf - p_obs)./p_obs)*100;

% high-skill industries shares
h_shares = [(1-alphai-deltai)];

industry = (1:N)';

% % % aggregate effect % % %

% aggregate labour share
(PAY_L + PAY_H)/(PAY_K + PAY_L + PAY_H)

% gross output shares
go_i = pq_obs/sum(pq_obs);



%% Export data


filename = 'Counterfactuals_UKA8_LH_noIO.xls';
CF = table(industry,alphai,deltai,h_shares,mu,beta,ki_cf,li_cf,hi_cf,p_cf,q_cf,y_cf,dqidH_cf);
writetable(CF,filename,'Sheet',1,'Range','B2')
AUX = table(alpha,delta,Y_cf,wK_cf,wL_cf,wH_cf);
        writetable(AUX,filename,'Sheet',2,'Range','B2')

% % % aggregate effect % % %
filename = 'Aggregate_Effect_UKA8_EnoIO.xls';
    LHnoIO = table(industry,q_obs,q_cf);
        writetable(LHnoIO,filename,'Sheet',1,'Range','B2')
