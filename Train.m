function [Traindata, Testdata, testType] = Train(SMRCSPFirst_1,SMRCSPLast_1,SMRCSPFirst_2, SMRCSPLast_2, class1, class2)
trainTrials = 25;
testTrials = 5;
[Traindata] = band (SMRCSPFirst_1,SMRCSPLast_1, SMRCSPFirst_2, SMRCSPLast_2, trainTrials);
[Testdata] = band (SMRCSPFirst_1(:,trainTrials+1:end),SMRCSPLast_1(:,trainTrials+1:end), SMRCSPFirst_2(:,trainTrials+1:end), SMRCSPLast_2(:,trainTrials+1:end), testTrials);
    for tnum=1:trainTrials
        testType(tnum) = {class1};
        testType(trainTrials+tnum) = {class2};
    end
end
