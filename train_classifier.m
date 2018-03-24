trainTrials = 25;
testTrials = 5;
[Traindata] = band (SMRCSPFirst_1,SMRCSPLast_1, SMRCSPFirst_2, SMRCSPLast_2, trainTrials);
[Testdata] = band (SMRCSPFirst_1(:,trainTrials+1:end),SMRCSPLast_1(:,trainTrials+1:end), SMRCSPFirst_2(:,trainTrials+1:end), SMRCSPLast_2(:,trainTrials+1:end), testTrials);
for tnum=1:trainTrials
    testType(tnum) = {'Class 1'};
    testType(trainTrials+tnum) = {'Class 2'};
end
MdlLinear = fitcdiscr(Traindata, testType);
class = predict(MdlLinear, Testdata);
