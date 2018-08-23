function plotData(responses,title)
% Plots all channels in data file as a subplot.
% Inputs: data_file (.mat file) data file containing channel data
close all;
accelerometers = responses(:,2:5);
accelerometer_names = {'11LW Northside', '11LW Southside', ...
                        '40LW Northside', '40LW Southside'};
                    
displacements = responses(:,6:7);
displacement_names = {'40LW Northside', '40LW Southside'};

num_readings = size(responses,1);

sampling_rate = 66.67; % 4000 readings a minute
time = (1:num_readings)./sampling_rate;

fig = figure;

%figure
plot(time,accelerometers)
%ylim([0,12])
legend(accelerometer_names,'location','southoutside','orientation','horizontal');
%set(leg1,'Interpreter','latex');
ylabel('Acceleration [ms^{-2}]')%,'Interpreter','latex')
%xlabel('Time [s]','Interpreter','latex')

% subplot(2,1,2)
% plot(time,displacements)
% 
% legend(displacement_names,'location','southoutside','orientation','horizontal');
% %set(leg2,'Interpreter','latex');
% ylabel('Displacement [mm]')%,'Interpreter','latex')
% xlabel('Time [s]')%,'Interpreter','latex')

t = suptitle(title)
%set(t,'Interpreter','latex');

outfile = fullfile(rootDir(),'Paper','images',strcat(title,'.pdf'));
orient(fig,'landscape')
print(fig,outfile,'-bestfit','-dpdf')


end % plotData.m

