function preProcessData(response)

response = response - mean(response);

xmin = 60; xmax = 80;
ymin = -0.2; ymax = 1.2;

% Raw input data
close all;
time = linspace(0,length(response)/66.67,length(response));
plot(time,response); xlabel('Time [s]'); ylabel('Acceleration [ms^{-2}]'); title('Raw Readings')

%saveFigPDF(fullfile(rootDir(),'Paper','images','Raw_Data.pdf'))

% Normalised data
%Sfigure('units','normalized','outerposition',[0 0 1 1])
subplot(4,1,1)
norm_response = normaliseSignal(response);
plot(time,norm_response); title('Normalised Readings'); %xlabel('Time [secs]'); ylabel('Acceleration [ms^{-2}]');
xlim([xmin,xmax])
ylim([-1.2,1.2])

% Finding the envolope
% move RMS
subplot(4,1,2)
w = 5;
RMS_data = moveRMS(norm_response,w);
plot(time, RMS_data); title('Move RMS'); %ylabel('Acceleration [ms^{-2}]');
leg1 = legend(strcat(['$w = ',num2str(w),'$']));
set(leg1,'Interpreter','Latex')
xlim([xmin,xmax])
ylim([ymin,ymax])

% peak to peak
subplot(4,1,3)
p = 5;
PK_data = envelope(norm_response,p,'peak');
plot(time, PK_data); title('Peak to Peak'); %xlabel('Time [secs]'); ylabel('Acceleration [ms^{-2}]');
leg2 = legend(strcat(['$p = ',num2str(p),'$']));
set(leg2,'Interpreter','Latex')
xlim([xmin,xmax])
ylim([ymin,ymax])

% analytic signal
subplot(4,1,4)

fl = 230; 
AL_data = envelope(norm_response);
plot(time, AL_data); title('Analytic Signal'); % ylabel('Acceleration [ms^{-2}]');
xlabel('Time [s]');
% leg3 = legend(strcat(['$fl = ', num2str(fl),'$']));
% set(leg3,'Interpreter','Latex')
xlim([xmin,xmax])
ylim([ymin,ymax])
suplabel('Acceleration [ms^{-2}]','y');

%title('Peak to Peak'); xlabel('Time [secs]'); ylabel('Acceleration [ms^{-2}]');
saveFigPDF(fullfile(rootDir(),'Paper','images','Envelopes.pdf'))
