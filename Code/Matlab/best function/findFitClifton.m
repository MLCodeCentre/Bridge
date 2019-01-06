function findFitClifton

files_Clifton_dir = fullfile(dataDir(),'Test Samples','Clifton_1');
Clifton_files = dir(fullfile(files_Clifton_dir,'*.mat'));
num_responses = size(Clifton_files,1);
shuff = randperm(num_responses);
Clifton_files = Clifton_files(shuff);

for file_ind = 1:num_responses
    % Clifton
    file_name = Clifton_files(file_ind).name;
    responses_load = load(fullfile(files_Clifton_dir,file_name));
    responses = responses_load.responses;
    response = responses(:,4);
    envelope = processData(response);
    %plot(envelope)
    
    %% fitting
    t = linspace(0,120,8000);
    theta_0 =  [1,1,1,60,0];     

    lb = [0,   0,    0.1,   5,   0];
    ub = [20, 20,    2,     115, 0.005];

    f = @(theta,t) weibellFit(t,theta);

    problem = createOptimProblem('lsqcurvefit','x0',theta_0,'objective',f,...
    'lb',lb,'ub',ub,'xdata',t,'ydata',envelope);
  
    ms = MultiStart();
    [theta_solve,errormulti] = run(ms,problem,10)
    plot(t,envelope,t,weibellFit(t,theta_solve))
             
end