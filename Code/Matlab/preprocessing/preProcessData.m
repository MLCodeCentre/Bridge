function preProcessData(response)

% Raw input data
close all;
time = linspace(0,length(response)/66.67,length(response));
plot(time,response); title('Raw Data'); xlabel('Time [secs]'); ylabel('Acceleration [ms^{-2}]');

% Normalised data
figure;
norm_response = normaliseSignal(response);
plot(time,norm_response); title('Normliased Data'); xlabel('Time [secs]'); ylabel('Acceleration [ms^{-2}]');

% Finding the envolope
figure;
% move RMS
subplot(3,1,1)
w = 20;
RMS_data = moveRMS(norm_response,w);
plot(time, RMS_data); title('Move RMS'); ylabel('Acceleration [ms^{-2}]');
leg1 = legend('$w = 20$');
set(leg1,'Interpreter','Latex')

% peak to peak
subplot(3,1,2)
p = 20;
PK_data = envelope(norm_response,p,'peak');
plot(time, PK_data); title('Peak to Peak'); xlabel('Time [secs]'); ylabel('Acceleration [ms^{-2}]');
leg2 = legend('$p = 20$');
set(leg2,'Interpreter','Latex')

% analytic signal
subplot(3,1,3)

AL_data = envelope(norm_response,200);
plot(time, AL_data); title('Analytic Signal'); ylabel('Acceleration [ms^{-2}]');

