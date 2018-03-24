function [Tdata] = band_noCSP(SMR1, SMR2, SMR3, trials)
    for tnum = 1:trials
        band1 (tnum) = bandpower(SMR1(tnum,:));
        band2 (tnum)= bandpower(SMR2(tnum,:));
        band3 (tnum)= bandpower(SMR3(tnum,:));
    end
    Tdata = transpose([band1; band2; band3]);
end