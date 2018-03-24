%%% LOAD DATA %%%
% load all movement files into the workspace
load('rightHand');
load('leftHand');
load('tongue');
load('foot');
run_iterations = 3; % there are six classification pairs
for i = 1:run_iterations
    if i == 1
        RawEEG1 = rightHand;
        RawEEG2 = foot;
        offset_1 = 9.5;
        offset_2 = 6.3;
        class1 = 'Right';
        class2 = 'Foot';
    elseif i == 2
        RawEEG1 = leftHand;
        RawEEG2 = foot;
        offset_1 = 9.3;
        offset_2 = 6.3;
        class1 = 'Left';
        class2 = 'Foot';
    elseif i == 3
        RawEEG1 = tongue;
        RawEEG2 = foot;
        offset_1 = 10.1;
        offset_2 = 6.3;
        class1 = 'Tongue';
        class2 = 'Foot';
    end

    %%% DATA SETUP %%%
    sampleRate = 250;
%     if strcmp(data2,'foot')
        movementTime = 2; % set to 2s if foot is one of the movements, otherwise should be 5s
%     else
%         movementTime = 5;
%     end
    restTime = 3; 
    trialTime = movementTime + restTime;
    numberSamples = 30;

    %%% TEMPORAL FILTERING %%%
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
    EpochStartTime_1 = offset_1:trialTime:offset_1 + trialTime*(numberSamples-1);
    EpochStartTime_2 = offset_2:trialTime:offset_2 + trialTime*(numberSamples-1);

    % Convert start times using sample rate
    EpochStartTime_1 = EpochStartTime_1*sampleRate;
    EpochStartTime_2 = EpochStartTime_2*sampleRate;

    trialLength = movementTime*sampleRate;

    %%% COMMON SPATIAL FILTER %%%
    [ SMRCSPFirst_1, SMRCSPLast_1, SMRCSPFirst_2, SMRCSPLast_2 ] = ...
        CSP( EEG_filtered1, EEG_filtered2, EpochStartTime_1, EpochStartTime_2, trialLength);
    
    %%% TRAIN PAIRED CLASSIFIER
    [Traindata, Testdata, testType] = Train(SMRCSPFirst_1,SMRCSPLast_1,SMRCSPFirst_2, SMRCSPLast_2, class1, class2);
    if i == 1
        TraindataT = Traindata;
        TestdataT = Testdata;
        testTypeT = testType';
    else
        TraindataT = [TraindataT; Traindata];
        TestdataT = [TestdataT; Testdata];
        testTypeT = [testTypeT; testType'];
    end
end

MdlLinear = fitcdiscr(TraindataT, testTypeT);
class = predict (MdlLinear, TestdataT);