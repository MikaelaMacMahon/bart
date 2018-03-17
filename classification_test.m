clear all;
close all;
% load data
load rawEEG.mat;

% house keeping variables
% variables relating to sampling rate and experimental epoches (trials)
sampleRate = 250; % sampling rate (Hz)
epochRange = [-3,6]; % epoch range, with respect to the cue (s)
trialTimeIdx = (round(sampleRate*epochRange(1))+1):round(sampleRate*epochRange(2)); % time indics for plotting (samples)
baselineRange = [-0.9 -0.1]; % the range over which the baseline is calculated
baselineIdx = ((round(sampleRate*baselineRange(1))+1):round(baselineRange*epochRange(2)))...
    - round(epochRange(1)*sampleRate); % time indics for baseline period (samples)

% % Getting the starting time all movement trials
% left hand epoch starting time:
leftEpochStartTime=find(rawEEG(63,:)==1);
% right hand epoch starting time:
rightEpochStartTime=find(rawEEG(63,:)==2);

EEGrawC3 = rawEEG([16 17 18 25 26 27 34 35 36],:);
EEGrawC4 = rawEEG([20 21 22 29 30 31 38 39 40],:);
spatial_filter = [-1 -1 -1 -1 8 -1 -1 -1 -1];
data_spatial_filtered_C3 = spatial_filter*EEGrawC3;
data_spatial_filtered_C4 = spatial_filter*EEGrawC4;

Fs = 250; %for wireless EEG headset
filt_n = 2;
Wn = [0.05 3]/(Fs/2); %movement related cortical potential cutoff point
[filter_b, filter_a] = butter(filt_n, Wn);

[ C3LeftSMR, C4LeftSMR, C3RightSMR, C4RightSMR ] = ...
    mySMRCalculation( filter_a, filter_b, data_spatial_filtered_C3, data_spatial_filtered_C4, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx);