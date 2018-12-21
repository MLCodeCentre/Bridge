function resnorm = findBestFunction()

close all

files_Clifton_dir = fullfile(dataDir(),'Test Samples','LW_1');
files_LW_dir = fullfile(dataDir(),'Test Samples','LW_1');

Clifton_files = dir(fullfile(files_Clifton_dir,'*.mat'));
LW_files = dir(fullfile(files_LW_dir,'*.mat'));

function_types = {'LogNormal','Exp','Gamma','Weibell'};
%function_types = {'LogNormal'};
num_function_types = length(function_types);

num_responses = 10; % each

norms = zeros(2*num_responses,num_function_types);

for function_type_ind = 1:num_function_types
    function_type = function_types(function_type_ind);
    
    for file_ind = 1:num_responses
        fprintf('Fitting %s to file %d\n',char(function_type),file_ind);
        % Clifton
        file_name = Clifton_files(file_ind).name;
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
        file_name = LW_files(file_ind).name;
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
save(fullfile(dataDir(),'September','norms.mat'),'norms')   
