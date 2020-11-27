clear all;
clc;
close all;

load('../cardinality_data/cardinalities.mat');
load('../cardinality_data/timediffs.mat');

data_size = size(cardinalities);

card_diff = zeros(data_size);
total_timediffs = zeros(data_size);

card_diff(1:data_size - 1) = abs(diff(cardinalities));

for i = 1:data_size
    total_timediffs(i) = sum(timediffs(1:i));
end

x = 1:data_size;

%% plot graphs one by one
% p1 = plotyy(x, cardinalities, x, timediffs);
% title('Cardinality vs Time Difference')
% xlabel('Iteration')
% ylabel(p1(1),'Cardinality') % left y-axis 
% ylabel(p1(2),'Time Difference') % right y-axis
% print('cardinality_cost_outputs/cardinality_cost_outputscard-timediff','-dpng');
% 
% figure,
% p2 = plotyy(x, cardinalities, x, total_timediffs);
% title('Cardinality vs Total Time Spent')
% xlabel('Iteration')
% ylabel(p2(1),'Cardinality') % left y-axis 
% ylabel(p2(2),'Total Time Spent') % right y-axis
% print('cardinality_cost_outputs/card-totaltime','-dpng');
% 
% figure,
% p3 = plotyy(x, card_diff, x, timediffs);
% title('Cardinality Difference vs Time Difference')
% xlabel('Iteration')
% ylabel(p3(1),'Cardinality Difference') % left y-axis 
% ylabel(p3(2),'Time Difference') % right y-axis
% print('cardinality_cost_outputs/card-diff-timediff','-dpng');
% 
% figure,
% p4 = plotyy(x, card_diff, x, total_timediffs);
% title('Cardinality Difference vs Total Time Spent')
% xlabel('Iteration')
% ylabel(p4(1),'Cardinality Difference') % left y-axis 
% ylabel(p4(2),'Total Time Spent') % right y-axis
% print('cardinality_cost_outputs/card-diff-totaltime','-dpng');

%% plot graphs in one window 
figure,
subplot(2, 2, 1);
p1 = plotyy(x, cardinalities, x, timediffs);
title('Cardinality vs Time Difference')
xlabel('Iteration')
ylabel(p1(1),'Cardinality') % left y-axis 
ylabel(p1(2),'Time Difference') % right y-axis

subplot(2, 2, 2)
p2 = plotyy(x, cardinalities, x, total_timediffs);
title('Cardinality vs Total Time Spent')
xlabel('Iteration')
ylabel(p2(1),'Cardinality') % left y-axis 
ylabel(p2(2),'Total Time Spent') % right y-axis

subplot(2, 2, 3)
p3 = plotyy(x, card_diff, x, timediffs);
title('Cardinality Difference vs Time Difference')
xlabel('Iteration')
ylabel(p3(1),'Cardinality Difference') % left y-axis 
ylabel(p3(2),'Time Difference') % right y-axis

subplot(2, 2, 4)
p4 = plotyy(x, card_diff, x, total_timediffs);
title('Cardinality Difference vs Total Time Spent')
xlabel('Iteration')
ylabel(p4(1),'Cardinality Difference') % left y-axis 
ylabel(p4(2),'Total Time Spent') % right y-axis

print('../cardinality_cost_outputs/total-graph','-dpng');

