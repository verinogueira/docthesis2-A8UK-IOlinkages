%% UK, YEAR 2014, 29 INDUSTRIES
% constructs the baseline dataset

% clear everything
clear
close all
clc

% load data file
load('OBS2014.mat')

% VARIABLES ARE IN VECTORS (29 X 1) %

%% ANALYSIS

% NARROW low-skill shares industries
l_shares = deltai;

% NARROW high-skill shares industries
h_shares = (1-alphai-deltai);

% NARROW labour shares industries
e_shares = (1-alphai);

% NARROW capital shares industries
k_shares = alphai;

% BROAD low-skill industries shares
l_shares_adj = (1-gammai).*deltai;

% BROAD high-skill industries shares
h_shares_adj = (1-gammai).*(1-alphai-deltai);

% BROAD labour (employment) industries shares
e_shares_adj = (1-gammai).*(1-alphai);


% industries weights (shares) on total nominal gross output
pq_weight = pq_obs/sum(pq_obs);



% weighted average purchases from high-skill intensive industries
L_in_wi = l_shares.*Gamma./gammai';
L_in = sum(L_in_wi)';

L_in_net = L_in - l_shares;


% weighted average purchases from high-skill intensive industries
H_in_wi = h_shares.*Gamma./gammai';
H_in = sum(H_in_wi)';

H_in_net = H_in - h_shares;




% LEONTIEF-INVERSE TRANSPOSED
Gamma_effect = (eye(N)-Gamma')^(-1);

% IO model: total effect (Corollary 2.2)
link_LS_i = (eye(N)-Gamma')\l_shares_adj;  
link_HS_i = (eye(N)-Gamma')\h_shares_adj;  
link_ES_i = (eye(N)-Gamma')\e_shares_adj;


% linkage weights matrix
weights_matrix = Gamma_effect.*(1-gammai)';



% approximation matrices
% rows have each order of approximation per industry
% 4th decimal convergence no later than 17th order
LS_effect = zeros(N,N);
for n = 1:N
    m=n-1;
LS_effect(:,n)=ShockDecomp (m, N, Gamma, l_shares_adj);   
end

HS_effect = zeros(N,N);
for n = 1:N
    m=n-1;
HS_effect(:,n)=ShockDecomp (m, N, Gamma, h_shares_adj);   
end

ES_effect = zeros(N,N);
for n = 1:N
    m=n-1;
ES_effect(:,n)=ShockDecomp (m, N, Gamma, e_shares_adj);   
end

% test all 1s
test_LS = LS_effect(:,N)./link_LS_i; 
test_HS = HS_effect(:,N)./link_HS_i;
test_ES = ES_effect(:,N)./link_ES_i;

% ratios of order over total effect
% to capture speed of convergence across industries
% industries in the rows, orders in the columns
LS_app_ratios = zeros(N,N);
for n = 1:N
LS_app_ratios(:,n)=LS_effect(:,n)./link_LS_i;   
end

HS_app_ratios = zeros(N,N);
for n = 1:N
HS_app_ratios(:,n)=HS_effect(:,n)./link_HS_i;   
end

ES_app_ratios = zeros(N,N);
for n = 1:N
ES_app_ratios(:,n)=ES_effect(:,n)./link_ES_i;   
end


% vectors of aggregate factor shares (for Stata)
LS_share = delta;
LS_share_vc = ones(N,1).*LS_share;

HS_share = 1-alpha-delta;
HS_share_vc = ones(N,1).*HS_share;

ES_share = 1-alpha;
ES_share_vc = ones(N,1).*ES_share;



industry = (1:N)';

%% GENERATE DATA FOR OTHER FILES
% save data file
save('ANL2014.mat')

% VARIABLES ARE IN VECTORS (29 X 1) %
 