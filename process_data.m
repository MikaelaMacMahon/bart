%% Load data
data1 = 'righthand'; % change the data variables based on what movements you want to classify
data2 = 'foot'; % always set the foot variable as data2
load(data1);
load(data2);
RawEEG1 = data1;
RawEEG2 = data2;

%% Data Setup
sampleRate = 250;
if strcmp(data2,'foot')
    movementTime = 2; % set to 2s if foot is one of the movements, otherwise should be 5s
else
    movementTime = 5;
end
restTime = 3; 
trialTime = movementTime + restTime;
numberSamples = 30;

%% Temporal Filtering
% frequency and temporal filtering parameters
freqRange = [8, 26]; % the range of frequencies over which SMR is calculated
% filter parameters
filtOrder = 4; % filter order
Wn = freqRange/(sampleRate/2); % frequency range w.r.t. to Nyquist rate
[filterB,filterA] = butter(filtOrder,Wn); % temporal filter coefficients
EEG_filtered1 = filtfilt(filterB,filterA,RawEEG1);
EEG_filtered2 = filtfilt(filterB,filterA,RawEEG2);

% 60 Hz notch filter
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',sampleRate);
EEG_filtered1 = filter(d,EEG_filtered1);
EEG_filtered2 = filter(d,EEG_filtered2);

% Starting time all movement trials
offset_1 = 9.5; % change this based on the start time of each movement
offset_2 = 6.3;
EpochStartTime_1 = offset_1:trialTime:offset_1 + trialTime*(numberSamples-1);
EpochStartTime_2 = offset_2:trialTime:offset_2 + trialTime*(numberSamples-1);

% Convert start times using sample rate
EpochStartTime_1 = EpochStartTime_1*sampleRate;
EpochStartTime_2 = EpochStartTime_2*sampleRate;

trialLength = movementTime*sampleRate;

%% Common Spatial Filter
[ SMRCSPFirst_1, SMRCSPLast_1, SMRCSPFirst_2, SMRCSPLast_2 ] = ...
    CSP( EEG_filtered1, EEG_filtered2, EpochStartTime_1, EpochStartTime_2, trialLength);