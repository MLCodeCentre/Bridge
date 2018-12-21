function getResults(barrier,total)

total = num2str(total)
% Analyse ones get
folder = strcat([barrier,'_',total,]);

files = dir(fullfile(dataDir,'Test Samples',folder,'*.mat'));
num_files = size(files,1);
shuff = randperm(num_files);
files = files(shuff);
results = {};
pcafs = [];
logLqs = [];
for file_num = 1:num_files
    
    close all
    
    file = files(file_num);
    file_name = file.name
    %file_name = '7.mat';
    full_file_name = fullfile(dataDir,'Test Samples',folder,file_name);
    file_load = load(full_file_name);
    responses = file_load.responses;
    response = responses(:,4); % 40LW N
    plot(response)
    label = str2num(total);
    close
    if label > 0
        try
            [num_vehicles,~,~] = main(response);
            %pcafs = [pcafs;pcaf];
            %logLqs = [logLqs; logLq];
            
            result = {full_file_name, label, num_vehicles};
            results{file_num} = result;
            targets(file_num) = label
            computed(file_num) = num_vehicles
        catch e %e is an MException struct
            fprintf(1,'The identifier was:\n%s',e.identifier);
            fprintf(1,'There was an error! The message was:\n%s',e.message);
            results{file_num} = {'Error'}
            % more error handling...
        end
    else
        results{file_num} = {'No vehicle'}  
    end
end
%out_file = fullfile(dataDir,'Test Samples',folder,);
%save('','results')

disp('-------------RESULTS-------------')
fprintf('----%d vehicle(s), %s barrier----\n',total,barrier)
fprintf('Number of Test Samples: %d\n',length(computed))
fprintf('Accuracy: %.2f\n ',sum(targets==computed)/length(computed))

end

