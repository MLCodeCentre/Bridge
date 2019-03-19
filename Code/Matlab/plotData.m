function plotData(responses)

close all
time = linspace(0,length(responses(:,2))/66.67,length(responses(:,2)));

% 11LW North
subplot(4,1,1)
plot(time,responses(:,2)-mean(responses(:,2)))
title('11LW North')
% 11LW South
subplot(4,1,2)
plot(time,responses(:,3)-mean(responses(:,3)))
title('11LW South')
% 40LW North
subplot(4,1,3)
plot(time,responses(:,4)-mean(responses(:,4)))
title('40LW North')
% 40LW South
subplot(4,1,4)
plot(time,responses(:,5)-mean(responses(:,5)))
title('40LW South')
    
xlabel('t [s]')
suplabel('Acceleration [ms^{-2}]','y');

saveFigPDF(fullfile(rootDir,'Paper','images','All_raw_chans_Clifton.pdf'))
end % plotData.m



