%%% LOAD DATA %%%
% load all movement files into the workspace
load('rightHand');
load('leftHand');
load('foot');

RawEEG1 = rightHand;
RawEEG2 = leftHand;
RawEEG3 = foot;

%%% DATA SETUP %%%
sampleRate = 250;
movementTime_foot = 2; % set to 2s if foot is one of the movements, otherwise should be 5s
movementTime_left_right = 5;
restTime = 3; 
trialTime_foot = movementTime_foot + restTime;
trialTime_left_right = movementTime_left_right + restTime;
numberSamples = 30;

% Starting time all movement trials
offset_1 = 9.5;
offset_2 = 9.3;
offset_3 = 6.3;
EpochStartTime_1 = offset_1:trialTime_left_right:offset_1 + trialTime_left_right*(numberSamples-1);
EpochStartTime_2 = offset_2:trialTime_left_right:offset_2 + trialTime_left_right*(numberSamples-1);
EpochStartTime_3 = offset_3:trialTime_foot:offset_3 + trialTime_foot*(numberSamples-1);

% Convert start times using sample rate
EpochStartTime_1 = EpochStartTime_1*sampleRate;
EpochStartTime_2 = EpochStartTime_2*sampleRate;
EpochStartTime_3 = EpochStartTime_3*sampleRate;

trialLengthLeftRight = movementTime_left_right*sampleRate;
trialLengthFoot = movementTime_foot*sampleRate;

%%% TEMPORAL FILTERING %%%
% frequency and temporal filtering parameters
freqRange = [8, 26]; % the range of frequencies over which SMR is calculated
% filter parameters
filtOrder = 2; % filter order
Wn = freqRange/(sampleRate/2); % frequency range w.r.t. to Nyquist rate
[filterB,filterA] = butter(filtOrder,Wn); % temporal filter coefficients
EEG_filtered1 = filtfilt(filterB,filterA,RawEEG1);
EEG_filtered2 = filtfilt(filterB,filterA,RawEEG2);
EEG_filtered3 = filtfilt(filterB,filterA,RawEEG3);

% 60 Hz notch filter
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',sampleRate);
EEG_filtered1 = filter(d,EEG_filtered1);
EEG_filtered2 = filter(d,EEG_filtered2);
EEG_filtered3 = filter(d,EEG_filtered3);

%%% FIND SMR %%%
[ C3RightSMR, C4RightSMR, CzRightSMR, C3LeftSMR, C4LeftSMR, CzLeftSMR, C3FootSMR, C4FootSMR, CzFootSMR ] = ...
SMR_calculation( EEG_filtered1, EEG_filtered2, EEG_filtered3, EpochStartTime_1, EpochStartTime_2, EpochStartTime_3, trialLengthLeftRight, trialLengthFoot);

trainTrials = 25;
testTrials = 5;
[Tdata1] = band_noCSP(C3RightSMR, C4RightSMR, CzRightSMR, numberSamples);
[Tdata2] = band_noCSP(C3LeftSMR, C4LeftSMR, CzLeftSMR, numberSamples);
[Tdata3] = band_noCSP(C3FootSMR, C4FootSMR, CzFootSMR, numberSamples);

for tnum=1:trainTrials
        testType(tnum) = {'Left'};
end
for tnum=1:trainTrials
        testType(trainTrials+tnum) = {'Right'};
end
for tnum=1:trainTrials
        testType(2*trainTrials+tnum) = {'Foot'};
end

Tdata = [Tdata1(1:25, :);Tdata2(1:25, :);Tdata3(1:25, :)];
Testdata = [Tdata1(26:30, :);Tdata2(26:30, :);Tdata3(26:30, :)];
MdlLinear = fitcdiscr(Tdata, testType);
class = predict(MdlLinear, Testdata);