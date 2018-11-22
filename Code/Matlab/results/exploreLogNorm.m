function exploreLogNorm

close all

Mus = 0:3;
Sigmas = 1;

t = 0:0.01:20;
i =1;
for Mu = Mus
    for Sigma = Sigmas
        y = lognpdf(t,Mu,Sigma);
        plot(t,y)
        hold on
        leg_info{i} = sprintf('Mu %.1f, Sigma %.1f',Mu,Sigma);
        i = i+1;
    end
end
legend(leg_info)
xlim([-5,20])
ylim([0,1])