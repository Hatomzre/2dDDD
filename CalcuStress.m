function appliedStress = CalcuStress(appliedStress, vnNew, dt, vfext, vth)
%This function calculates the applied stress

appliedStress(6) = appliedStress(6) + ...
    vfext.*dt.*(sum(sum(abs(vnNew)))/size(vnNew, 1)<=vth);
end