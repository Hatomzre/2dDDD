function vn = drndt(rn, appliedStress, mob, a, force, xBound, yBound, MU)
%This function calculates the velocity for each dislocation

%----Calculating The Force For Each Dislocation----------------------------
fn = feval(force, rn, appliedStress, a, xBound, yBound, MU);

%----Calculating The Velocity For Each Dislocation-------------------------
vn = mobility(rn, fn, mob);
end