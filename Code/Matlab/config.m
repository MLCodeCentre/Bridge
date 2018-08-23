function params = config()
% Define parameters and values that are to be called.
% Outputs:
% params struct. A struct of system parameters. 

%% parameters for fitExp.m
params.exp_params0 = [2, 2]; % instantiate parameters and fit lsq to data
params.exp_lower_bounds = [0.01, 0, 0];%, 0];
params.exp_upper_bounds = [5, 1, 60];%, 1];

%% parameters for fitLogNorm.m
                         %A   simga  mu  tau
params.ln_params0 =      [1.92, 1.33,  0.45   ]; % instantiate parameters and fit lsq to data                        
params.ln_lower_bounds = [0.5,  0.2,   0.2,   0];
params.ln_upper_bounds = [3,    2,     1.5,   55];
params.x_star = 0.03;

%% parameters for fitLogNormFixedMu.m
params.lnfm_params0 = [1.5, 1]; % instantiate parameters and fit lsq to data
                         %A   simga   tau
params.lnfm_lower_bounds = [1,  0.05,   5];
params.lnfm_upper_bounds = [3,   2.5,   55];

%% parameters for fitFuncToData
params.itters = 3; % how many curves to fit
params.MinPeakDistance = 2; % distance between peaks in findpeaks algorithm [s]
params.MinPeakHeight = 0.5; % min height of peaks in findpeaks algorithm
params.offset = 2; % the function is fitted this far behind the peak
params.sampling_rate = 66.67; % sampling rate of data [Hz]

%% parameters for loadData and LoadOnes
params.file_thresh = '240'; % data folder to be analysed 
params.data_length = 4000; % length of each data file
params.num_files = 2; % number of files to load
params.window_size = 10; % window size for which the variance is calculated in [s]
params.number_readings_per_minute = 4000;

end %config()