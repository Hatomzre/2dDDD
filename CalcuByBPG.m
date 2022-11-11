function [rnNew, vnNew, newdt] = CalcuByBPG(rn, ~, dt, appliedStress, ...
        mob, a, conError, xBound, yBound, force, energy, dtMax, MU)
%This function solves 2D dd by BPG method

%----Prepare Some Variables For Calculation--------------------------------
rn0 = rn;
rn1 = rn;
NofD = size(rn, 1);
E0 = feval(energy, rn0, a, appliedStress, xBound, ...
        yBound);
vn = drndt(rn0, appliedStress, mob, a, force, xBound, yBound, MU);
iter = 1;

%----Calculate By BPG Method-----------------------------------------------
while 1
    %----Updata The Position For Each Dislocation--------------------------
    rn1(:, 1:2) = rn0(:, 1:2) + dt*vn;

    %----Calculate The Energy Change---------------------------------------
    E1 = feval(energy, rn1, a, appliedStress, xBound, ...
        yBound);
    deltaE = E0 - E1;

    %----Calculate The Position Change-------------------------------------
    deltaR = sum(sum((rn1(:, 1:2)-rn0(:, 1:2)).^2))/NofD;

    %----Check The Condition-----------------------------------------------
    if deltaE/deltaR >= conError
        vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);
        deltavn = abs(sum(sum((rn1(:, 1:2)-rn0(:, 1:2)).*(vn1-vn))))/NofD;
        alpha = deltaR/deltavn;
        break;
    else
        dt = dt/2;
    end
    
    %----Check The Time Step Not 0-----------------------------------------
    if dt < 1e-20
        error('Time step size fell below minimum\n');
    end

    iter = iter + 1;
end

rnNew = rn1;
vnNew = vn1;

%----Optimize The Time Step------------------------------------------------
if iter == 1
    maxChange = 1.2;
    dt = min(maxChange*dt, dtMax);
end
newdt = max(dtMax*alpha/(1+alpha), dt);

end