function [rnNew, vnNew, dt] = CalcuByFRCG(rn, vn, dt, appliedStress, ...
        mob, a, conError, xBound, yBound, force, energy, dtMax, MU)
%This function solves 2D dd by FRCG method

%----Prepare Some Variables For Calculation--------------------------------
rn0 = rn;
rn1 = rn;
NofD = size(rn, 1);
iter = 1;
E0 = feval(energy, rn0, a, appliedStress, xBound, ...
        yBound);
vn0 = drndt(rn0, appliedStress, mob, a, force, xBound, yBound, MU);
restartCG = 0;

%----Calculate By FRCG Method----------------------------------------------
while 1
    %----Updata The Position For Each Dislocation--------------------------
    rn1(:, 1:2) = rn0(:, 1:2) + dt*vn;

    %----Calculate The Energy Change---------------------------------------
    E1 = feval(energy, rn1, a, appliedStress, xBound, ...
        yBound);
    deltaE = E0 - E1;

    %----Calculate The Position Change-------------------------------------
    deltav = sum(sum(vn0.*vn))/NofD;

    %----Check The Wolfe Condition-----------------------------------------
    if deltaE/deltav >= conError
        vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);
        beta = min(sum(sum(vn1.^2))/sum(sum(vn0.^2)), 0.5);
        break;
    else
        dt = dt/2;
    end
    
    %----Check Restart CGmethod--------------------------------------------
    if ~restartCG && dt < 1e-5
        vn = vn0;
        dt = dtMax;
        restartCG = 1;
    elseif restartCG && dt < 1e-20
    %----Check The Time Step Not 0-----------------------------------------
        error('Time step size fell below minimum\n');
    end

    iter = iter + 1;
end

rnNew = rn1;
vnNew = vn1 + beta*vn;

%----Optimize The Time Step------------------------------------------------
if iter == 1
    maxchange = 1.2;
    dt = min(maxchange*dt, dtMax);
end

end