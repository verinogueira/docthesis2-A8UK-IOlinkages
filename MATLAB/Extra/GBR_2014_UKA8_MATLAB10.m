%% UK, YEAR 2014, 29 INDUSTRIES
%counterfactual to both high-skilled and low-skilled A8 below

%clear everything
clear
close all
clc

%control parameters
%T = 2; %years of data
N = 29; %no industries

%% Load constructed dataset 2014

load('All2014.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COUNTERFACTUAL: 10% 

%List of things changed in the counterfactual:
K_cf = K_obs;
L_cf = L_obs*1.1;
H_cf = H_obs*1.1;

lK_cf = log(K_cf);
lL_cf = log(L_cf);
lH_cf = log(H_cf);


%1) solve for prices and Y
lY_cf = alpha*(lK_cf-lalpha) + delta*(lL_cf-ldelta) + (1-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*(1-gammai).*alphai.*lalphai) + sum(mu.*(1-gammai).*deltai.*ldeltai) + ... 
    sum(mu.*(1-gammai).*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*(1-gammai).*log(1-gammai)) + sum(mu.*lA) + sum(mu.*sum(Gamma.*log(Gamma),1)') + sum(beta.*lbeta);
Y_cf = exp(lY_cf);

lwL_cf = alpha*(lK_cf-lalpha) - (1-delta)*(lL_cf-ldelta) + (1-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*(1-gammai).*alphai.*lalphai) + sum(mu.*(1-gammai).*deltai.*ldeltai) + ... 
    sum(mu.*(1-gammai).*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*(1-gammai).*log(1-gammai)) + sum(mu.*lA) + sum(mu.*sum(Gamma.*log(Gamma),1)') + sum(beta.*lbeta);
wL_cf = exp(lwL_cf);

lwH_cf = alpha*(lK_cf-lalpha) + delta*(lL_cf-ldelta) + (-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*(1-gammai).*alphai.*lalphai) + sum(mu.*(1-gammai).*deltai.*ldeltai) + ... 
    sum(mu.*(1-gammai).*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*(1-gammai).*log(1-gammai)) + sum(mu.*lA) + sum(mu.*sum(Gamma.*log(Gamma),1)') + sum(beta.*lbeta);
wH_cf = exp(lwH_cf);

lwK_cf = (alpha-1)*(lK_cf-lalpha) + delta*(lL_cf-ldelta) + (1-alpha-delta)*(lH_cf-log(1-alpha-delta)) + ...
    sum(mu.*(1-gammai).*alphai.*lalphai) + sum(mu.*(1-gammai).*deltai.*ldeltai) + ... 
    sum(mu.*(1-gammai).*(1-alphai-deltai).*log(1-alphai-deltai)) + ... 
    sum(mu.*(1-gammai).*log(1-gammai)) + sum(mu.*lA) + sum(mu.*sum(Gamma.*log(Gamma),1)') + sum(beta.*lbeta);
wK_cf = exp(lwK_cf);

%2) solve for quantities and factor usage of each industry
lki_cf = log(alphai) + log(1-gammai) + log(mu) + lY_cf - lwK_cf;
lli_cf = log(deltai) + log(1-gammai) + log(mu) + lY_cf - lwL_cf;
lhi_cf = log(1-alphai-deltai) + log(1-gammai) + log(mu) + lY_cf - lwH_cf;

ki_cf = exp(lki_cf);
li_cf = exp(lli_cf);
hi_cf = exp(lhi_cf);


% DISCUSSION %
% test: should be zero
test_K = sum(ki_cf) - K_cf;
test_L = sum(li_cf) - L_cf;
test_H = sum(hi_cf) - H_cf;
if test_K >= 1e-08 | test_L >= 1e-09 | test_H >= 1e-10
    disp('check K, L, H')  
end




% calculate qi: 1) and 2)
% 1) define V vector (86)
V = lA + lmu + (1-gammai).*alphai.*(lK_cf+lalphai-lalpha) + (1-gammai).*deltai.*(lL_cf+ldeltai-ldelta) + ...
    (1-gammai).*(1-alphai-deltai).*(lH_cf+log(1-alphai-deltai)-log(1-alpha-delta)) + (1-gammai).*log(1-gammai) + ...
    sum(Gamma.*log(Gamma),1)' - sum(Gamma.*log(mu),1)';

% alternative V (75)
V2 = lA + lmu + (1-gammai).*lY_cf +(1-gammai).*alphai.*(lalphai-lwK_cf) + (1-gammai).*deltai.*(ldeltai-lwL_cf) + ...
    (1-gammai).*(1-alphai-deltai).*(log(1-alphai-deltai)-lwH_cf) + (1-gammai).*log(1-gammai) + ...
    sum(Gamma.*log(Gamma),1)' - sum(Gamma.*log(mu),1)';
if abs(sum(V - V2)) >= 1e-13    % error: 2.5757e-14
    disp('check V')
end


% 2) find q = (1-Gamma')^(-1)*V can be written as
lq_cf = (eye(N)-Gamma')\V;  % = inv(eye(N)-Gamma')*V
q_cf = exp(lq_cf);


%calculate dij = (Gamma_ji * mu_i * q_j)/mu_j
d_cf = Gamma.*mu'./mu.*q_cf;


%calculate yi = (beta_i * q_i)/mu_i
y_cf = beta.*q_cf./mu;

Y_cf_test = prod(y_cf.^beta); % REAL OUTPUT: Cobb-Douglas aggregator final good
if abs(Y_cf_test - Y_cf) >= 1e-07          % error = 1.3970e-09
    disp('Cobb-Douglas cf dnt hold')
end

% TEST market clearing
if q_cf < y_cf
    disp('q smaller than y')
end

% y_cf has to be positive
% sum(d_obs,2): total production II / sum over columns, same row / (3X1)
y_cf_MC = q_cf - sum(d_cf,2);
if min(y_cf_MC) <= 0
    disp('q smaller than d')
end

% TEST: difference close to zero
test_y_MC_cf = y_cf_MC - y_cf;
if abs(min(test_y_MC_cf)) >= 1e-08      % error: 1.8626e-09
    disp('check y cf')
end


%calculate pi: 1) and 2)
% 1) define W vector
W = -lA -(1-gammai).*alphai.*(lalphai-lwK_cf) -(1-gammai).*deltai.*(ldeltai-lwL_cf) - ...
  (1-gammai).*(1-alphai-deltai).*(log(1-alphai-deltai)-lwH_cf) - (1-gammai).*log(1-gammai) - ...
  sum(Gamma.*log(Gamma),1)';

% 2) find p = (1-Gamma')^(-1)*W can be written as
lp_cf = (eye(N)-Gamma')\W;
p_cf = exp(lp_cf);


pq_cf = p_cf.*q_cf;
py_cf = p_cf.*y_cf;
PY_cf = sum(py_cf);


% check P=1
P_cf = PY_cf./Y_cf;
if abs(P_cf - 1) >= 1e-14          % error = 5.5511e-16
    disp('P_cf not equal to 1')
end

% check mu
mu_cf = pq_cf/Y_cf;
if max(abs(mu_cf - mu)) >= 1e-13       % error = 1.2490e-15
    disp('mu_cf not equal to 1')
end

%% Results

(1-alpha)*10

dYdH_cf = ((Y_cf - Y_obs)/Y_obs)*100

% dwKdH_cf = ((wK_cf - wK_obs)/wK_obs)*100;
% dwLdH_cf = ((wL_cf - wL_obs)/wL_obs)*100;
% dwHdH_cf = ((wH_cf - wH_obs)/wH_obs)*100;
% dkidH_cf = ((ki_cf - k_obs)./k_obs)*100;
% dlidH_cf = ((li_cf - l_obs)./l_obs)*100;
% dhidH_cf = ((hi_cf - h_obs)./h_obs)*100;
% 
% 
% industry = (1:N)';
% 
% % % % aggregate effect % % %
% 
% % gross output shares
% go_i = pq_obs/sum(pq_obs);
% 
% 
% 
% %% Export data
% 
% filename = 'Counterfactuals_UKA8_E1.xls';
%     CF = table(industry,alphai,deltai,h_shares,gammai,gamma_out,H_in_weighted,mu,beta,ki_cf,li_cf,hi_cf,p_cf,q_cf,y_cf,d_cf);
%         writetable(CF,filename,'Sheet',1,'Range','B2')
%     AUX = table(alpha,delta,Y_cf,wK_cf,wL_cf,wH_cf);
%         writetable(AUX,filename,'Sheet',2,'Range','B2')
% 
% % % % aggregate effect % % %
% filename = 'Aggregate_Effect_UKA8_EIO.xls';
%     LHIO = table(industry,e_shares,go_i,q_obs,q_cf);
%         writetable(LHIO,filename,'Sheet',1,'Range','B2')
% 
