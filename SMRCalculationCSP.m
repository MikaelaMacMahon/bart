function [ leftSMRCSPFirst, leftSMRCSPLast, rightSMRCSPFirst, rightSMRCSPLast ] = mySMRCalculationCSP( filterB, filterA, EEG, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx)

% filtering the signal 
eegFiltered = transpose(filtfilt (filterB, filterA, EEG'));

% extract epochs of left and right hand movements (including all channels)
% left
for epochID=1:length(leftEpochStartTime)
    leftEpoches(:,:,epochID) = eegFiltered(:,leftEpochStartTime(1,epochID)+trialTimeIdx(1):(leftEpochStartTime(1,epochID)+trialTimeIdx(end)));
end

% right
for epochID=1:length(rightEpochStartTime)
   rightEpoches(:,:,epochID) = eegFiltered(:,rightEpochStartTime(1,epochID)+trialTimeIdx(1):rightEpochStartTime(1,epochID)+trialTimeIdx(end));
end

%Reshape 3D matrix to 2D matrix to apply covariance matrix
leftEpochesCov = reshape (leftEpoches,18,[]);
rightEpochesCov = reshape (rightEpoches,18,[]);

% calculating the covarinace matrix for both classes (note CSP works on the
% raw signal, not the power).
% left class
SigmaL = cov (leftEpochesCov');

% right class
SigmaR = cov (rightEpochesCov');

% solving the generalized eigenvalue problem
% Note here SigmaL is the first input argumen. Here for simplicity, we take 
% the first column of W as the corresponding component for Left hand movement;
% and the last column of W is the corresponding component for right hand movement
[W,~] = eig(SigmaL, SigmaL + SigmaR);

% left class after CSP
for epochID = 1:size(leftEpoches,3)
    leftEpochesCSP(:,:,epochID) = W'*leftEpoches(:,:,epochID);
end
% right class after CSP
for epochID = 1:size(rightEpoches,3)
    rightEpochesCSP(:,:,epochID) = W'*rightEpoches(:,:,epochID);
end

% As noted above, we only take the first and the last component for left
% hand and right hand, respectively.
leftEpochesAvePowerCSPFirst = sum(leftEpochesCSP(1,:,:).^2,3)/size(leftEpoches,3);
leftEpochesAvePowerCSPLast =  sum(leftEpochesCSP(end,:,:).^2,3)/size(leftEpoches,3);

rightEpochesAvePowerCSPFirst = sum(rightEpochesCSP(1,:,:).^2,3)/size(rightEpoches,3);
rightEpochesAvePowerCSPLast = sum(rightEpochesCSP(end,:,:).^2,3)/size(rightEpoches,3);

% find the power of the baseline range
leftBaselinePowerCSPFirst = sum(sum(leftEpochesCSP(1,baselineIdx(1):baselineIdx(end),:).^2,3)/size(leftEpoches,3),2)/size(baselineIdx,2);
leftBaselinePowerCSPLast = sum(sum(leftEpochesCSP(end,baselineIdx(1):baselineIdx(end),:).^2,3)/size(leftEpoches,3),2)/size(baselineIdx,2);

rightBaselinePowerCSPFirst = sum(sum(rightEpochesCSP(1,baselineIdx(1):baselineIdx(end),:).^2,3)/size(rightEpoches,3),2)/size(baselineIdx,2);
rightBaselinePowerCSPLast = sum(sum(rightEpochesCSP(end,baselineIdx(1):baselineIdx(end),:).^2,3)/size(rightEpoches,3),2)/size(baselineIdx,2);

% calculate the SMR of the trials (substract the baseline power, then
% normalized w.r.t. the baseline power)
leftSMRCSPFirst = ((leftEpochesCSP(1,:,:).^2 - leftBaselinePowerCSPFirst)/leftBaselinePowerCSPFirst)*100;
leftSMRCSPLast = ((leftEpochesCSP(end,:,:).^2 - leftBaselinePowerCSPLast)/leftBaselinePowerCSPLast)*100;

rightSMRCSPFirst = ((rightEpochesCSP(1,:,:).^2 - rightBaselinePowerCSPFirst)/rightBaselinePowerCSPFirst)*100;
rightSMRCSPLast = ((rightEpochesCSP - rightBaselinePowerCSPLast)/rightBaselinePowerCSPLast)*100;

end

