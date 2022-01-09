%% UK, YEAR 2014, 29 INDUSTRIES
% Robstness test: using PARAMETERS OF 2003 on 2014's data
% No-IO model
%counterfactual to both high-skilled and low-skilled A8 below

%clear everything
clear
close all
clc

%control parameters
N = 29; %no industries

%% PARAMETERS from 2003

load('PAR2003noIO.mat')

%logs: log(X) returns the natural logarithm ln(x) of each element in array X
lA = log(A);

lbeta = log(beta);
lmu = log(mu);

lalpha = log(alpha);
ldelta = log(delta);

lalphai = log(alphai);
ldeltai = log(deltai);




%% EXOGENOUS VARIABLES


% Factors: k, l and h (KLEMS data UK)
%capital
k_data = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','F2:F30');
k_data(29) = 0.1; % zero has to be replaced by near zero
%total labour employed
e_data = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','H2:H30');
%low skill
l_shr = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','B2:B30');
l_data = l_shr.*e_data;
%high skill
h_shr = readmatrix('Data_GBR_2014.xls','Sheet','pri_qua','Range','C2:C30');
h_data = h_shr.*e_data;

% factor supplies
K_obs = sum(k_data);
L_obs = sum(l_data);
H_obs = sum(h_data);

% logs
lki_obs = log(k_data);
lli_obs = log(l_data);
lhi_obs = log(h_data);

lK_obs = log(K_obs);
lL_obs = log(L_obs);
lH_obs = log(H_obs);




%% ENDOGENOUS VARIABLES

%1) solve for factor prices and PY
lwL_obs = alpha*(lK_obs-lalpha) - (1-delta)*(lL_obs-ldelta) + (1-alpha-delta)*(lH_obs-log(1-alpha-delta)) + ...
    sum(mu.*alphai.*lalphai) + sum(mu.*deltai.*ldeltai) + ... 
    sum(mu.*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*lA) + sum(beta.*lbeta);
wL_obs = exp(lwL_obs);

lwH_obs = alpha*(lK_obs-lalpha) + delta*(lL_obs-ldelta) + (-alpha-delta)*(lH_obs-log(1-alpha-delta)) + ...
    sum(mu.*alphai.*lalphai) + sum(mu.*deltai.*ldeltai) + ... 
    sum(mu.*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*lA) + sum(beta.*lbeta);
wH_obs = exp(lwH_obs);

lwK_obs = (alpha-1)*(lK_obs-lalpha) + delta*(lL_obs-ldelta) + (1-alpha-delta)*(lH_obs-log(1-alpha-delta)) + ...
    sum(mu.*alphai.*lalphai) + sum(mu.*deltai.*ldeltai) + ... 
    sum(mu.*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*lA) + sum(beta.*lbeta);
wK_obs = exp(lwK_obs);

PY_obs = wK_obs*K_obs/alpha;
lPY_obs = log(PY_obs);


%2) solve for quantities and factor usage of each industry
lki_obs = log(alphai) + log(mu) + lPY_obs - lwK_obs;
lli_obs = log(deltai) + log(mu) + lPY_obs - lwL_obs;
lhi_obs = log(1-alphai-deltai) + log(mu) + lPY_obs - lwH_obs;

ki_obs = exp(lki_obs);
li_obs = exp(lli_obs);
hi_obs = exp(lhi_obs);


% test: should be zero
test_K = sum(ki_obs) - K_obs;
test_L = sum(li_obs) - L_obs;
test_H = sum(hi_obs) - H_obs;
if test_K >= 1e-08 | test_L >= 1e-09 | test_H >= 1e-10
    disp('check K, L, H')  
end




% calculate qi
lq_obs = lA + lmu + alphai.*(lK_obs+lalphai-lalpha) + deltai.*(lL_obs+ldeltai-ldelta) + ...
    (1-alphai-deltai).*(lH_obs+log(1-alphai-deltai)-log(1-alpha-delta));
q_obs = exp(lq_obs);

% test
lq_obs2 = lA + lmu + lPY_obs + alphai.*(lalphai-lwK_obs) + deltai.*(ldeltai-lwL_obs) + ...
    (1-alphai-deltai).*(log(1-alphai-deltai)-lwH_obs);
if abs(sum(lq_obs - lq_obs2)) >= 1e-13    % error: 6.9278e-14
    disp('check V')
end

%calculate yi 
y_obs = q_obs;



% calculate pi 
lp_obs = -lA -alphai.*(lalphai-lwK_obs) -deltai.*(ldeltai-lwL_obs) - ...
  (1-alphai-deltai).*(log(1-alphai-deltai)-lwH_obs);
p_obs = exp(lp_obs);


pq_obs = p_obs.*q_obs;
py_obs = p_obs.*y_obs;

% test
PY_obs_test = sum(py_obs);
if abs(PY_obs_test - PY_obs) >= 1e-07          % error =  8.3819e-09
    disp('Check PY')
end




% REAL OUTPUT: Cobb-Douglas aggregator final good
Y_obs = prod(y_obs.^beta); 
if abs(Y_obs - PY_obs) >= 1e-07          % error =  8.3819e-09
    disp('Cobb-Douglas cf dnt hold')
end


% check P=1
P_obs = PY_obs./Y_obs;
if abs(P_obs - 1) >= 1e-14          % error = 2.4425e-15
    disp('P_obs not equal to 1')
end


%% CHECK PARAMETERS 

% check mu
mu_obs = pq_obs/Y_obs;
if max(abs(mu_obs - mu)) >= 1e-13       % error = 1.3045e-15
    disp('mu_obs not equal to mu')
end

% beta: final consumption shares on Y (sum to one)
beta_obs = py_obs / PY_obs;
if max(abs(beta_obs - beta)) >= 1e-13       % error = 6.1062e-16
    disp('beta_obs not equal to mu')
end

% industry-specific factor shares 
alphai_obs = (wK_obs*ki_obs)./(pq_obs); 
deltai_obs = (wL_obs*li_obs)./(pq_obs);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COUNTERFACTUAL: removing A8 immigrants to both high-skilled and low-skilled labour supply 

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
dkidH_cf = ((ki_cf - k_data)./k_data)*100;
dlidH_cf = ((li_cf - l_data)./l_data)*100;
dhidH_cf = ((hi_cf - h_data)./h_data)*100;

% calculate effects on qi
dqidH_cf = ((q_cf - q_obs)./q_obs)*100;

% PRICES: calculate effects on pi
dpidH_cf = ((p_cf - p_obs)./p_obs)*100;

% high-skill industries shares
h_shares = [(1-alphai-deltai)];

industry = (1:N)';

% % % aggregate effect % % %

% gross output shares
go_i = pq_obs/sum(pq_obs);

% labour shares
e_shares = 1 - alphai;

%% Export data

% % % aggregate effect % % %
EnoIO = table(industry,e_shares,go_i,q_obs,q_cf);
    filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Stata\Input'; 
    filename = 'PAR2003_UKA8_EnoIO.xls';
    writetable(EnoIO,fullfile(filepath, filename),'Sheet',1,'Range','B2')


