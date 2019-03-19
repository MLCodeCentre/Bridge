function plotParamHists(theta)

close all

theta = theta(theta(:,1)<2 & theta(:,2)<1.9, :);

mus = theta(:,1);
sigmas = theta(:,2);


hist(mus(mus<2),20)
xlabel('\mu')
ylabel('Frequency')

figure
hist(sigmas(sigmas<1.9),20)
xlabel('\sigma')
ylabel('Frequency')

figure
scatter(mus,sigmas)
xlabel('\mu [ms^{-2}]')
ylabel('\sigma [ms^{-2}]')
grid on
