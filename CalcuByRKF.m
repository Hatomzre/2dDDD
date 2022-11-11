function [rnNew, vnNew, dt] = CalcuByRKF(rn, ~, dt, appliedStress, ...
        mob, a, conError, xBound, yBound, force, ~, dtMax, MU)
%This function solves 2D dd by RKF45 method

%----Prepare Some Variables For Calculation--------------------------------
rn0 = rn;
rn1 = rn;
NofD = size(rn, 1);
iter = 1;
q = zeros(NofD, 12);
vn = drndt(rn0, appliedStress, mob, a, force, xBound, yBound, MU);

%----Calculate By RKF45 Method---------------------------------------------
while 1
    q(:, 1:2) = vn;
    f1 = 1/4;
    rn1(:, 1:2) = rn0(:, 1:2) + dt*f1*q(:, 1:2);
    %----Calculate velocity for dislocations-------------------------------
    vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);

    q(:, 3:4) = vn1;
    f1 = 3.0/32;
    f2 = 9.0/32;
    rn1(:, 1:2) = rn0(:, 1:2) + dt*(f1*q(:, 1:2)+f2*q(:, 3:4));
    vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);

    q(:,5:6) = vn1;
    f1 = 1932.0/2197;
    f2 = -7200.0/2197;
    f3 = 7296.0/2197;
    rn1(:, 1:2) = rn0(:, 1:2) + dt*(f1*q(:, 1:2)+f2*q(:, 3:4)+f3*q(:, 5:6));
    vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);

    q(:, 7:8) = vn1;
    f1 = 439.0/216;
    f2 = -8.0;
    f3 = 3680.0/513;
    f4 = -845.0/4104;    
    rn1(:, 1:2) = rn0(:, 1:2) + dt*(f1*q(:, 1:2)+f2*q(:, 3:4)+ ...
        f3*q(:, 5:6)+f4*q(:, 7:8));
    vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);

    q(:, 9:10) = vn1;
    f1 = -8.0/27;
    f2 = 2.0;
    f3 = -3544.0/2565;
    f4 = 1859.0/4104;
    f5 = -11.0/40;
    rn1(:, 1:2) = rn0(:, 1:2) + dt*(f1*q(:, 1:2)+f2*q(:, 3:4)+ ...
        f3*q(:, 5:6)+f4*q(:, 7:8)+f5*q(:, 9:10));
    vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);

    %----Estimate The Error------------------------------------------------
    q(:, 11:12) = vn;
    f1 = 1.0/360;
    f2 = 0.0;
    f3 = -128.0/4275;
    f4 = -2197.0/75240;
    f5 = 1.0/50;
    f6 = 2.0/55;
    err = dt*(f1*q(:, 1:2)+f2*q(:, 3:4)+f3*q(:, 5:6)+f4*q(:, 7:8)+ ...
        f5*q(:, 9:10)+f6*q(:, 11:12));
    errmag = max(max(abs(err)));

    if errmag < conError
        f1 = 16.0/135;
        f2 = 0.0;
        f3 = 6656.0/12825;
        f4 = 28561.0/56430;
        f5 = -9.0/50;
        f6 = 2.0/55;
        rn1(:, 1:2) = rn0(:, 1:2) + dt*(f1*q(:, 1:2)+f2*q(:, 3:4)+ ...
            f3*q(:, 5:6)+f4*q(:, 7:8)+f5*q(:, 9:10)+f6*q(:, 11:12));
        vn1 = drndt(rn1, appliedStress, mob, a, force, xBound, yBound, MU);
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
    maxchange = 1.2;
    exponent = 20;
    factor = maxchange*(1/(1+(maxchange^exponent-1)*(errmag/conError)))^(1/exponent);
    dt = min(dt*factor, dtMax);
end

end