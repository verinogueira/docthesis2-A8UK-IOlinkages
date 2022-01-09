%% UK, YEAR 2014, 29 INDUSTRIES
% counterfactual: shock to both high-skilled and low-skilled A8 stock

% clear everything
clear
close all
clc


% load data files
load('ANL2014.mat')
load('CFT2014_L.mat')
load('CFT2014_H.mat')
load('CFT2014_E.mat')


% VARIABLES ARE IN VECTORS (29 X 1) %

%% Export data
 
% approximations: ratios of order over total effect
% to capture speed of convergence across industries
% industries in the rows, orders in the columns
 
 APP_LS = table(industry,LS_app_ratios);
   filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Stata\Input'; 
   filename = 'Approximations_UKA8_2014.xls';
    writetable(APP_LS,fullfile(filepath, filename),'Sheet',1,'Range','A1')

 APP_HS = table(industry,HS_app_ratios);
   filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Stata\Input'; 
   filename = 'Approximations_UKA8_2014.xls';
   writetable(APP_HS,fullfile(filepath, filename),'Sheet',2,'Range','A1')
 
 APP_ES = table(industry,ES_app_ratios);
   filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Stata\Input'; 
   filename = 'Approximations_UKA8_2014.xls';
   writetable(APP_ES,fullfile(filepath, filename),'Sheet',3,'Range','A1')


% industry values
% parameters, constructed variables and conterfactual output changes
 CC = table(industry,k_shares,l_shares,h_shares,e_shares,gammai,pq_weight,L_in,L_in_net,H_in,H_in_net,dqidL_cf,dqidH_cf,dqidE_cf,dqidL_ratios,dqidH_ratios);
   filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Stata\Input'; 
   filename = 'Summary_UKA8_2014.xls';
   writetable(CC,fullfile(filepath, filename),'Sheet',1,'Range','A1')

    
% aggregate values
 AGG = table(LS_share,HS_share,ES_share,dYdL_cf,dwKdL_cf,dwLdL_cf,dwHdL_cf,dYdH_cf,dwKdH_cf,dwLdH_cf,dwHdH_cf,dYdE_cf,dwKdE_cf,dwLdE_cf,dwHdE_cf);
  filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Stata\Input'; 
  filename = 'Aggregate_UKA8_2014.xls';
  writetable(AGG,fullfile(filepath, filename),'Sheet',1,'Range','A1')
 
