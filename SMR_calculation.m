function [ C3RightSMR, C4RightSMR, CzRightSMR, C3LeftSMR, C4LeftSMR, CzLeftSMR, C3FootSMR, C4FootSMR, CzFootSMR ] = ...
        SMR_calculation( EEG_filtered1, EEG_filtered2, EEG_filtered3, EpochStartTime_1, EpochStartTime_2, EpochStartTime_3, trialLengthLeftRight, trialLengthFoot)

%%% SPATIAL FILTERING %%%
% use small Laplacian filtering 
laplace_filter = [-1 -1  8 -1 -1];
C3Right = laplace_filter*EEG_filtered1([10,11,15,19,20],:); % right hand centered at C3
C4Right = laplace_filter*EEG_filtered1([12,13,17,21,22],:); % right hand centered at C4
CzRight = laplace_filter*EEG_filtered1([11,12,16,20,21],:); % right hand centered at Cz
C3Left = laplace_filter*EEG_filtered2([10,11,15,19,20],:); % right hand centered at C3
C4Left = laplace_filter*EEG_filtered2([12,13,17,21,22],:); % right hand centered at C4
CzLeft = laplace_filter*EEG_filtered2([11,12,16,20,21],:); % right hand centered at Cz
C3Foot = laplace_filter*EEG_filtered3([10,11,15,19,20],:); % right hand centered at C3
C4Foot = laplace_filter*EEG_filtered3([12,13,17,21,22],:); % right hand centered at C4
CzFoot = laplace_filter*EEG_filtered3([11,12,16,20,21],:); % right hand centered at Cz
    
for epochID=1:length(EpochStartTime_1)
    % extract epoches of right hand movements
    C3RightEpoches(epochID,:) = C3Right(EpochStartTime_1(epochID):EpochStartTime_1(epochID)+trialLengthLeftRight);
    C3RightEpochesPower(epochID,:) = C3RightEpoches(epochID,:).^2;
    C4RightEpoches(epochID,:) = C4Right(EpochStartTime_1(epochID):EpochStartTime_1(epochID)+trialLengthLeftRight);
    C4RightEpochesPower(epochID,:) = C4RightEpoches(epochID,:).^2;
    CzRightEpoches(epochID,:) = CzRight(EpochStartTime_1(epochID):EpochStartTime_1(epochID)+trialLengthLeftRight);
    CzRightEpochesPower(epochID,:) = CzRightEpoches(epochID,:).^2;
end
for epochID=1:length(EpochStartTime_2)
    % extract epoches of left hand movements
    C3LeftEpoches(epochID,:) = C3Left(EpochStartTime_2(epochID):EpochStartTime_2(epochID)+trialLengthLeftRight);
    C3LeftEpochesPower(epochID,:) = C3LeftEpoches(epochID,:).^2;
    C4LeftEpoches(epochID,:) = C4Left(EpochStartTime_2(epochID):EpochStartTime_2(epochID)+trialLengthLeftRight);
    C4LeftEpochesPower(epochID,:) = C4LeftEpoches(epochID,:).^2;
    CzLeftEpoches(epochID,:) = CzLeft(EpochStartTime_2(epochID):EpochStartTime_2(epochID)+trialLengthLeftRight);
    CzLeftEpochesPower(epochID,:) = CzLeftEpoches(epochID,:).^2;
end
for epochID=1:length(EpochStartTime_3)
    % extract epoches of foot movements
    C3FootEpoches(epochID,:) = C3Foot(EpochStartTime_3(epochID):EpochStartTime_3(epochID)+trialLengthFoot);
    C3FootEpochesPower(epochID,:) = C3FootEpoches(epochID,:).^2;
    C4FootEpoches(epochID,:) = C4Foot(EpochStartTime_3(epochID):EpochStartTime_3(epochID)+trialLengthFoot);
    C4FootEpochesPower(epochID,:) = C4FootEpoches(epochID,:).^2;
    CzFootEpoches(epochID,:) = CzFoot(EpochStartTime_3(epochID):EpochStartTime_3(epochID)+trialLengthFoot);
    CzFootEpochesPower(epochID,:) = CzFootEpoches(epochID,:).^2;
end

C3RightSMR = C3RightEpochesPower;
C4RightSMR = C4RightEpochesPower;
CzRightSMR = CzRightEpochesPower;
C3LeftSMR = C3LeftEpochesPower;
C4LeftSMR = C4LeftEpochesPower;
CzLeftSMR = CzLeftEpochesPower;
C3FootSMR = CzFootEpochesPower;
C4FootSMR = CzFootEpochesPower;
CzFootSMR = CzFootEpochesPower;

end

