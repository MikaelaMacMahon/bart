function [Tdata] = band(SMR1, SMR2, SMR3, SMR4, trials)
    for tnum = 1:trials
        band1 (tnum) = bandpower(SMR1(:,tnum));
        band2 (tnum)= bandpower(SMR2(:,tnum));
        band3 (tnum)= bandpower(SMR3(:,tnum));
        band4 (tnum)= bandpower(SMR4(:,tnum));
    end
    dataS1 = [band1; band2];
    dataS2 = [band3; band4];
    Tdata = transpose([dataS1, dataS2]);
end