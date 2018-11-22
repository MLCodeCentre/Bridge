function resnorm = findBestFunction()

close all

files_Clifton_dir = fullfile(dataDir(),'Clifton_total_1_threshold_2');
files_LW_dir = fullfile(dataDir(),'LW_total_1_threshold_2');

function_types = {'LogNormal','Exp','Gamma','Weibell'};
function_types = {'LogNormal'};
num_function_types = length(function_types);

num_responses = 10; % each

norms = zeros(2*num_responses,num_function_types);

for function_type_ind = 1:num_function_types
    function_type = function_types(function_type_ind);
    
    for file_ind = 1:num_responses
        fprintf('Fitting %s to file %d\n',char(function_type),file_ind);
        % Clifton
        file_name = strcat([num2str(file_ind),'.mat']);
        responses_load = load(fullfile(files_Clifton_dir,file_name));
        responses = responses_load.responses;
        response = responses(:,4);
        if size(response,1) == 8000
            [params, resnorm] = fitFunctionsToResponse(response,function_type);
            params
            MSE = resnorm/8000;
            norms(2*file_ind - 1,function_type_ind) = MSE;
        end
        % LW
        file_name = strcat([num2str(file_ind),'.mat']);
        responses_load = load(fullfile(files_LW_dir,file_name));
        responses = responses_load.responses;
        response = responses(:,4);
        
        %plotData(responses)
        if size(response,1) == 8000
            [params, resnorm] = fitFunctionsToResponse(response,function_type);
            params
            MSE = resnorm/8000;
            norms(2*file_ind,function_type_ind) = MSE;
        end
    end
end
norms
%save(fullfile(dataDir(),'September','norms.mat'),'norms')   
