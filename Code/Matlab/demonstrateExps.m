function demonstrateExps()

close all

data_load = load('1485309840.0_Clifton1_Leigh0_02_04.mat');
data = data_load.data;
data = data(1:4000, 2);
data = data';

time = linspace(0, 60, 60*66.67);
plot(time, data)
ylabel('Accelerometer Response')
xlabel('Time [s]')

figure; 
stats = getWindowedStats(data, 5);
plot(time, stats)
ylabel('Windowed Variance')
xlabel('Time [s]')

figure;

As = {0.1, 0.1, 0.2 0.2};
Bs = {1, 1.2, 1, 1.2};
Taus = {10, 20, 30, 40};
for i = 1:4
    x = genExp([As{i}, Bs{i}, Taus{i}, 2], time);
    plot(time,x)
    legendInfo{i} = strcat('A = ', num2str(As{i}), ', B = ', num2str(Bs{i}));
    hold on
end

legend(legendInfo)
title('$$\bf{\displaystyle x = Ate^{-\frac{t}{B}}}$$','interpreter','latex')
ylabel('x')
xlabel('Time [s]')

figure;
stats = getWindowedStats(data, 5);
plot(time, stats)
fit = fitExp(stats, time);
hold on
plot(time, fit)
ylabel('Windowed Variance with fit')
xlabel('Time [s]')