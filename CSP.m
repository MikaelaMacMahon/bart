function [ SMRCSPFirst_1, SMRCSPLast_1, SMRCSPFirst_2, SMRCSPLast_2 ] = CSP( EEG1, EEG2, EpochStartTime_1, EpochStartTime_2, trialLength)

% extract epochs of left and right hand movements (including all channels)

% left
for epochID=1:length(EpochStartTime_1)
    Epoches_1(:,:,epochID) = EEG1(:,EpochStartTime_1(epochID):EpochStartTime_1(epochID)+trialLength);
end
% reshape from 3D matrix back to 2D matrix
EpochesReshape_1 = reshape(Epoches_1,size(EEG1,1),[]);

% right
for epochID=1:length(EpochStartTime_2)
    Epoches_2(:,:,epochID) = EEG2(:,EpochStartTime_2(epochID):EpochStartTime_2(epochID)+trialLength);
end
EpochesReshape_2 = reshape(Epoches_2,size(EEG2,1),[]);

% covariance
% each column of matrix should be a channel 
% left class
Sigma1 = cov(EpochesReshape_1');

% right class
Sigma2 = cov(EpochesReshape_2');

% solving the generalized eigenvalue problem
% Note here SigmaL is the first input argumen. Here for simplicity, we take 
% the first column of W as the corresponding component for Left hand movement;
% and the last column of W is the corresponding component for right hand movement

[W,~] = eig(Sigma1, Sigma1 + Sigma2);

% left class after CSP
for epochID = 1:length(EpochStartTime_1)
    EpochesCSP_1(:,:,epochID) = W' * Epoches_1(:,:,epochID);
end
% right class after CSP
for epochID = 1:length(EpochStartTime_2)
    EpochesCSP_2(:,:,epochID) = W' * Epoches_2(:,:,epochID);
end

% As noted above, we only take the first and the last component for left
% hand and right hand, respectively.
EpochesCSPFirst_1 = EpochesCSP_1(1,:,:);
EpochesCSPLast_1 = EpochesCSP_1(size(EpochesCSP_1,1),:,:);

EpochesCSPFirst_2 = EpochesCSP_2(1,:,:);
EpochesCSPLast_2 = EpochesCSP_2(size(EpochesCSP_2,1),:,:);

EpochesCSPFirstPower_1 = EpochesCSPFirst_1 .^2;
EpochesCSPLastPower_1 = EpochesCSPLast_1 .^2;

EpochesCSPFirstPower_2 = EpochesCSPFirst_2 .^2;
EpochesCSPLastPower_2 = EpochesCSPLast_2 .^2;

SMRCSPFirst_1 = reshape(EpochesCSPFirstPower_1,[],size(EpochStartTime_1,2));
SMRCSPLast_1 = reshape(EpochesCSPLastPower_1,[],size(EpochStartTime_1,2));
SMRCSPFirst_2 = reshape(EpochesCSPFirstPower_2,[],size(EpochStartTime_2,2));
SMRCSPLast_2 = reshape(EpochesCSPLastPower_2,[],size(EpochStartTime_2,2));

end

