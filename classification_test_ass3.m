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

% frequency and temporal filtering parameters
freqRange = [8, 26]; % the range of frequencies over which SMR is calculated
% filter parameters
filtOrder = 4; % filter order
Wn = freqRange/(sampleRate/2); % frequency range w.r.t. to Nyquist rate
[filterB,filterA] = butter(filtOrder,Wn); % temporal filter coefficients

% % Getting the starting time all movement trials
% left hand epoch starting time:
leftEpochStartTime=find(rawEEG(63,:)==1);
% right hand epoch starting time:
rightEpochStartTime=find(rawEEG(63,:)==2);
% 
% % processing the raw EEG signals without spatial filtering
% % C3 = chan# 26, c4 = chan# 30
% 
% 
rawC3 = rawEEG(26,:);
rawEEG2Use = rawEEG([16:18,25:27,34:36,20:22,29:31,38:40],:);
%60 trials
[ leftSMRCSPFirst, leftSMRCSPLast, rightSMRCSPFirst, rightSMRCSPLast ] = ...
    SMRCalculationCSP( filterB, filterA, rawEEG2Use, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx);
size(leftSMRCSPFirst)
%Isolate left SMR CSP points
%Find valleys -> indications of ERD
for i=1:15
    filtData = filtfilt(filterB,filterA, leftSMRCSPFirst(1,:,i));
    plot(1:length(filtData), filtData);
    invertedLeftFirst = max(filtData) - filtData;
    size(invertedLeftFirst)
    [peaks, indexes] = findpeaks(invertedLeftFirst, 'MinPeakHeight',5);
    maxPeaks = find(peaks > -50);
    maxInds = indexes(maxPeaks);
    valleys = filtData(maxInds);
    figure
 %   plot(1:length(maxInds), peaks)
end



