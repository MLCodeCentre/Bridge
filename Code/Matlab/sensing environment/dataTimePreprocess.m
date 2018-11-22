function dataTimePreprocess

% use information in vehicle_counts.csv to create 1 minute windows of n cars 

params = config();

file = fullfile(rootDir(),'Data','Toll_barrier','vehical_counts.csv');
vehicle_counts = readtable(file);
%vehicle_counts = vehicle_counts(1:10,:);
num_counts = size(vehicle_counts,1);

times_before = [];
times_after = [];
year = [];
month = [];
day = [];
hour = [];

for row_num = 1:num_counts
    disp(strcat([num2str(row_num),'/',num2str(num_counts)]));
    if row_num == 1
        time_before = 0;
        time_after = vehicle_counts(row_num+1,:).datetime - vehicle_counts(row_num,:).datetime;
    elseif row_num == num_counts
        time_before = vehicle_counts(row_num,:).datetime - vehicle_counts(row_num-1,:).datetime;
        time_after = 0;
    else
        time_before = vehicle_counts(row_num,:).datetime - vehicle_counts(row_num-1,:).datetime;
        time_after = vehicle_counts(row_num+1,:).datetime - vehicle_counts(row_num,:).datetime;
    end
    times_before = [times_before; time_before];
    times_after = [times_after; time_after];
   
    [y,m,d] = ymd(vehicle_counts(row_num,:).datetime);
    [h,~,~] = hms(vehicle_counts(row_num,:).datetime);
    year = [year; y];
    month = [month; m];
    day = [day; d];
    hour = [hour; h];

end

table_full = [vehicle_counts table(times_before) table(times_after), table(year), table(month), table(day), table(hour)];
writetable(table_full,fullfile(rootDir(),'Data','Toll_barrier','vehicle_counts_times.csv'))




