%% UK, YEAR 2014, 29 INDUSTRIES
% constructs the baseline dataset

% clear everything
clear
close all
clc

% load data file
load('ANL2014.mat')

% VARIABLES ARE IN VECTORS (29 X 1) %


%% PLOTS - MAIN BODY OF PAPER

% Figure 2.3 (a) 
% IO plot TRANSPOSED
imagesc(Gamma');
%title('IO Matrix Transposed (\Gamma^I)');
set(gca,'FontSize',16)
x0=50;
y0=50;
width=1000;
height=600;
set(gcf,'position',[x0,y0,width,height])
xtickangle(90)
ylabel('Buying industries'), xlabel('Selling industries');
colorbar;
colormap (flipud(bone(64)));
%axis xy;
xticks([1:29])
yticks([1:29])
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = 'UKA8H_2014_IOT.png';
saveas(gcf, fullfile(filepath, filename), 'png');


% Figure 2.3 (b) 
% Leontief-inverse transposed
imagesc(Gamma_effect);
%title('IO effects: matrix [ I - \Gamma^I]^{-1}','fontsize',18);
set(gca,'FontSize',16)
x0=50;
y0=50;
width=1000;
height=600;
set(gcf,'position',[x0,y0,width,height])
xtickangle(90)
xlabel('Columns','fontsize',18), ylabel('Rows','fontsize',18);
colorbar;
colormap (flipud(bone(64)));
%axis xy;
xticks([1:29])
yticks([1:29])
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = 'Gamma_effect.png';
saveas(gcf, fullfile(filepath, filename), 'png'); 


% Figure 2.3 (c) 
% Linkage Weights matrix
imagesc(weights_matrix);
%title('Weights matrix [ I - \Gamma^I]^{-1}.(1-\gamma)','fontsize',18);
set(gca,'FontSize',16)
x0=50;
y0=50;
width=1000;
height=600;
set(gcf,'position',[x0,y0,width,height])
xtickangle(90)
xlabel('Columns','fontsize',18), ylabel('Rows','fontsize',18);
colorbar;
colormap (flipud(bone(64)));
%axis xy;
xticks([1:29])
yticks([1:29])
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = 'weights_matrix.png';
saveas(gcf, fullfile(filepath, filename), 'png'); 



% % % Plots for specific industries % % % 

% Purchases by industry: columns of Gamma
for n = 1:N
x = (1:N)';
y = Gamma(:,n)';
bar(x,y)
ylim([0 0.7])
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
set(gca,'FontSize',14)
title(sprintf('Columns of Gamma (industry %d)',n),'fontsize',14)
ylabel('Input shares','fontsize',14), xlabel('Goods','fontsize',14);
xticks([1:29]);
xticklabels({'A-B','C10-C12','C13-C15','C16-C18','C19','C20-C23','C24-C25','C26-C27','C28','C29-C30','C31-C33','D-E','F','G45','G46','G47','H49-H53','I','J58-J60','J61','J62-J63','K','L',	'M-N','O','P','Q','R-S','T'})
xtickangle(90)
x0=100;
y0=100;
width=650;
height=400;
set(gcf,'color','w','position',[x0,y0,width,height]);
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = sprintf('gammas_%d.png',n);
saveas(gcf, fullfile(filepath, filename), 'png'); 
end


% Leontief-inverse transpose: Gamma_effect by industry
for n = 1:N
x = (1:N)';
y = [Gamma_effect(n,:)];
bar(x,y)
ylim([0 2])
xticks([1:29])
xticklabels({'A-B','C10-C12','C13-C15','C16-C18','C19','C20-C23','C24-C25','C26-C27','C28','C29-C30','C31-C33','D-E','F','G45','G46','G47','H49-H53','I','J58-J60','J61','J62-J63','K','L',	'M-N','O','P','Q','R-S','T'})
xtickangle(90)
title(sprintf('Rows of matrix [ I - Gamma^I]^{-1} (industry %d)',n),'fontsize',14)
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
set(gca,'FontSize',14)
x0=10;
y0=10;
width=650;
height=400;
set(gcf,'color','w','position',[x0,y0,width,height]);
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = sprintf('effects_%d.png',n);
saveas(gcf, fullfile(filepath, filename), 'png'); 
end


% linkage weights by industry
for n = 1:N
x = (1:N)';
y = [weights_matrix(n,:)];
bar(x,y)
ylim([0 1])
xticks([1:29])
xticklabels({'A-B','C10-C12','C13-C15','C16-C18','C19','C20-C23','C24-C25','C26-C27','C28','C29-C30','C31-C33','D-E','F','G45','G46','G47','H49-H53','I','J58-J60','J61','J62-J63','K','L',	'M-N','O','P','Q','R-S','T'})
xtickangle(90)
title(sprintf('Linkage weights (industry %d)',n),'fontsize',14)
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
set(gca,'FontSize',14)
x0=10;
y0=10;
width=650;
height=400;
set(gcf,'color','w','position',[x0,y0,width,height]);
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = sprintf('weights_%d.png',n);
saveas(gcf, fullfile(filepath, filename), 'png'); 
end




%  plot ratios convergence by industry: LS CF
for n = 1:N
x = (1:N)';
y = [LS_effect(n,:)];
bar(x,y)
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
set(gca,'FontSize',14)
xticks([1:29]);
xtickangle(90)
title(sprintf('LS CF approximation ratios for Industry %d',n),'fontsize',14), xlabel('Orders of approximation','fontsize',14), ylabel('Approximated value over total effect','fontsize',14)
x0=10;
y0=10;
width=650;
height=400;
set(gcf,'color','w','position',[x0,y0,width,height]);
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = sprintf('gammas_%d.png',n);
saveas(gcf, fullfile(filepath, filename), 'png'); 

saveas(gcf,sprintf('approx_LS_ratios_%d.png',n))
end

%  plot ratios convergence by industry: HS CF
for n = 1:N
x = (1:N)';
y = [HS_effect(n,:)];
bar(x,y)
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
set(gca,'FontSize',14)
xticks([1:29]);
xtickangle(90)
title(sprintf('HS CF approximation ratios for Industry %d',n),'fontsize',14), xlabel('Orders of approximation','fontsize',14), ylabel('Approximated value over total effect','fontsize',14)
x0=10;
y0=10;
width=650;
height=400;
set(gcf,'color','w','position',[x0,y0,width,height]);
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = sprintf('approx_HS_ratios_%d.png',n);
saveas(gcf, fullfile(filepath, filename), 'png'); 
end


% Figure 2.19: IO plot 2014
imagesc(Gamma);
title('IO Matrix \Gamma');
set(gca,'FontSize',18)
xlabel('Buying industries'), ylabel('Selling industries');
colorbar;
colormap (flipud(bone(64)));
%axis xy;
xticks([1:29])
yticks([1:29])
 filepath = 'C:\Users\Veri\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Exhibits'; 
 filename = 'UKA8H_2014_IO.png';
saveas(gcf, fullfile(filepath, filename), 'png'); 






% %% PLOTS - EXTRA (not in main body)
% 
% 
% % plot approximation
% for n = 1:N
% x = (1:N)';
% y = [LS_effect(n,:)];
% bar(x,y)
% title(sprintf('Approximation for Industry %d',n)), xlabel('Order of approximation'), ylabel('Calculated effect of LS CF')
% saveas(gcf,sprintf('approx_LS_%d.png',n))
% end
% 
% for n = 1:N
% x = (1:N)';
% y = [HS_effect(n,:)];
% bar(x,y)
% title(sprintf('Approximation for Industry %d',n)), xlabel('Order of approximation'), ylabel('Calculated effect of HS CF')
% saveas(gcf,sprintf('approx_HS_%d.png',n))
% end
% 
% for n = 1:N
% x = (1:N)';
% y = [ES_effect(n,:)];
% bar(x,y)
% title(sprintf('Approximation for Industry %d',n)), xlabel('Order of approximation'), ylabel('Calculated effect of ES CF')
% saveas(gcf,sprintf('approx_ES_%d.png',n))
% end
% 
% 
% 
% 
% 
% % plot speed convergence
% % HS_effect(:,n)./link_HS_i
% 
% for n = 1:12
%     m=n-1;
% x = (1:N)';
% y = [LS_effect_speed(:,n)];
% bar(x,y,'FaceColor','#D95319','EdgeColor','#D95319')
% xticks([1:29])
% xticklabels({'A-B','C10-C12','C13-C15','C16-C18','C19','C20-C23','C24-C25','C26-C27','C28','C29-C30','C31-C33','D-E','F','G45','G46','G47','H49-H53','I','J58-J60','J61','J62-J63','K','L',	'M-N','O','P','Q','R-S','T'})
% xtickangle(90)
% ylim([0 1])
% grid on
% title(sprintf('Speed of convergence LS CF - %d th order',m)), xlabel('Industries'), ylabel('Approximated value over total effect')
% set(gcf,'color','w');
% saveas(gcf,sprintf('approx_LS_speed_%d.png',n))
% end
% 
% for n = 1:12
%     m=n-1;
% x = (1:N)';
% y = [HS_effect_speed(:,n)];
% bar(x,y,'FaceColor','#808080','EdgeColor','#808080')
% xticks([1:29])
% xticklabels({'A-B','C10-C12','C13-C15','C16-C18','C19','C20-C23','C24-C25','C26-C27','C28','C29-C30','C31-C33','D-E','F','G45','G46','G47','H49-H53','I','J58-J60','J61','J62-J63','K','L',	'M-N','O','P','Q','R-S','T'})
% xtickangle(90)
% ylim([0 1])
% grid on
% title(sprintf('Speed of convergence HS CF - %d th order',m)), xlabel('Industries'), ylabel('Approximated value over total effect')
% set(gcf,'color','w');
% saveas(gcf,sprintf('approx_HS_speed_%d.png',n))
% end
% 
% 
% for n = 1:12
%     m=n-1;
% x = (1:N)';
% y = [ES_effect_speed(:,n)];
% bar(x,y,'FaceColor','#ffda33','EdgeColor','#ffda33')
% xticks([1:29])
% xticklabels({'A-B','C10-C12','C13-C15','C16-C18','C19','C20-C23','C24-C25','C26-C27','C28','C29-C30','C31-C33','D-E','F','G45','G46','G47','H49-H53','I','J58-J60','J61','J62-J63','K','L',	'M-N','O','P','Q','R-S','T'})
% xtickangle(90)
% ylim([0 1])
% grid on
% title(sprintf('Speed of convergence ES CF - %d th order',m)), xlabel('Industries'), ylabel('Approximated value over total effect')
% set(gcf,'color','w');
% saveas(gcf,sprintf('approx_ES_speed_%d.png',n))
% end
% 
