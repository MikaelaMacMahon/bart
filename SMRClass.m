function [ C3LeftSMR, C4LeftSMR, C3RightSMR, C4RightSMR ] = ...
    mySMRCalculation( filterB, filterA, C3, C4, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx)

% filtering the signal 
C3Filtered = filtfilt(filterB,filterA,C3);
C4Filtered = filtfilt(filterB,filterA,C4);

%extract epochs of left and right hand movements
%power of the left epoches (how to get the power?)
for epochID=1:length(leftEpochStartTime)
    C3LeftEpoches(epochID,:) = C3Filtered(leftEpochStartTime(1,epochID)+trialTimeIdx(1):leftEpochStartTime(1,epochID)+trialTimeIdx(end));
    C4LeftEpoches(epochID,:) = C4Filtered(leftEpochStartTime(1,epochID)+trialTimeIdx(1):leftEpochStartTime(1,epochID)+trialTimeIdx(end));
end

%power of the right epoches
for epochID=1:length(rightEpochStartTime)
    C3RightEpoches(epochID,:) = C3Filtered(rightEpochStartTime(1,epochID)+trialTimeIdx(1):rightEpochStartTime(1,epochID)+trialTimeIdx(end));
    C4RightEpoches(epochID,:) = C4Filtered(rightEpochStartTime(1,epochID)+trialTimeIdx(1):rightEpochStartTime(1,epochID)+trialTimeIdx(end));
end

% find the power of the baseline range
C3LeftBaselinePower = sum(mean(C3LeftEpoches(:, baselineIdx(1):baselineIdx(end)).^2),2)/size(baselineIdx,2);
C4LeftBaselinePower = sum(mean(C4LeftEpoches(:, baselineIdx(1):baselineIdx(end)).^2),2)/size(baselineIdx,2);

C3RightBaselinePower = sum(mean(C3RightEpoches(:, baselineIdx(1):baselineIdx(end)).^2),2)/size(baselineIdx,2);
C4RightBaselinePower = sum(mean(C4RightEpoches(:, baselineIdx(1):baselineIdx(end)).^2),2)/size(baselineIdx,2);

% calculate the SMR of the trials (substract the baseline, then normalized
% w.r.t. the baseline
C3LeftSMR = ((C3LeftEpoches.^2 - C3LeftBaselinePower)/C3LeftBaselinePower)*100;
C4LeftSMR = ((C4LeftEpoches.^2 -C4LeftBaselinePower)/C4LeftBaselinePower)*100;
 
C3RightSMR = ((C3RightEpoches.^2-C3RightBaselinePower)/C3RightBaselinePower)*100;
C4RightSMR = ((C4RightEpoches.^2-C4RightBaselinePower)/C4RightBaselinePower)*100;

end

