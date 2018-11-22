function splitIntoCounts(toll,total,threshold)

% creating folder for data
folder = fullfile(rootDir(),'Data','September',strcat([toll,'_total_',num2str(total),'_threshold_',num2str(threshold)]));
if exist(folder, 'dir')
   disp('folder already exists')
else
   disp('creating folder')
   mkdir(folder)
end

%% loading vehicle data and filtering.
% threshold is how many minutes before and after, in minutes.
% length is how long the collected response is, will assume 1 minute.

vehicle_counts = readtable(fullfile(rootDir(),'Data','Toll_barrier','vehicle_counts_times.csv'));
% getting minutes that are isolated
before_okay = minute(datetime(char(vehicle_counts.times_before))) > threshold;
after_okay = minute(datetime(char((vehicle_counts.times_after)))) > threshold;
vehicle_counts = vehicle_counts(before_okay & after_okay,:);

% getting minutes that have right total
if strcmp(toll,'Clifton')
    counts_okay = vehicle_counts.Clifton_no_pass + vehicle_counts.Clifton_pass == total;
elseif strcmp(toll,'LW')
    counts_okay = vehicle_counts.LW_no_pass + vehicle_counts.LW_pass == total;
end
vehicle_counts = vehicle_counts(counts_okay,:);
fprintf('Found %d Toll Minutes with %d vehicles \n',size(counts_okay,1),total)

% getting minutes that are late at night.
[Hour, Min, Sec] = hms(vehicle_counts.datetime);
hour_okay = Hour < 7 | Hour > 22;
vehicle_counts = vehicle_counts(hour_okay,:);

%% Opening each spreadsheet and finding counts within there. 
struct_files = dir(fullfile(rootDir(),'Data','Structural Data Sample','*.csv'));
num_files = size(struct_files,1);
out_file_ind = 1;

for file_num = 1:num_files
    
    file_name = struct_files(file_num).name;
    info = strsplit(file_name,'_');
    [y,m,d] = ymd(datetime({info{3}}));
    
    counts_in_file = vehicle_counts.year == y & vehicle_counts.month == m & vehicle_counts.day == d;
    vehicle_counts_in_file = vehicle_counts(counts_in_file,:);
    datetimes_to_get = vehicle_counts_in_file.datetime;
    
    if size(datetimes_to_get,1) > 1
        fprintf('opening %s \n',file_name)
        readings = readtable(fullfile(rootDir(),'Data','Structural Data',file_name));
        
        num_datetimes = size(datetimes_to_get,1);
        for datetime_num = 1:num_datetimes
            response_datetime = datetimes_to_get(datetime_num);
            responses = getResponseFromFile(readings,response_datetime,120);
            if size(responses,1) > 0
                responses = calibrateResponses(responses);
                out_file_name = strcat(num2str(out_file_ind),'.mat');
                fprintf('saving %s \n',out_file_name)
                save(fullfile(folder,out_file_name),'responses');
                out_file_ind = out_file_ind + 1;
            end
        end
        clear readings
    end
end
end

function responses = getResponseFromFile(readings,response_datetime,time_after)
    response_start = posixtime(response_datetime);
    response_start_ind = find(readings.time_stamp/1000 == response_start);
    response_end_ind = floor(response_start_ind + time_after*66.666667);
    responses = readings(response_start_ind : min(size(readings,1),response_end_ind-1),:);
end

function responses = calibrateResponses(responses)
    responses = table2array(responses);
    responses(:,2) = responses(:,2)./1.7106e04; % 11LW Northside
    responses(:,3) = responses(:,3)./1.7664e04; % 11LW Southside
    responses(:,4) = responses(:,4)./1.7572e04; % 40LW Northside
    responses(:,5) = responses(:,5)./1.6937e04; % 40LW Southside
    responses(:,6) = responses(:,6)./505.157 + 8.324; % Displacement Northside
    responses(:,7) = responses(:,7)./503.048 + 5.114; % Displacement Northside    
end