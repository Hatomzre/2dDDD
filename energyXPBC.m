function Ener = energyXPBC(rn, a, appliedStress, xBound, yBound)
%This function calculates energy of the dislocation system in X PBC

%----Prepare Some Parameters-----------------------------------------------
N = size(rn, 1);
Ener = 0;
Ra = 1E16;
%----Get Burgers Vector----------------------------------------------------
if N ~= 0
    b(1:N, 1:3) = rn(1:N, 3:5);
end

%---Calculating The Energy For System--------------------------------------
for i = 2:N
    j = i:N;
    rnPart = rn(j, :);
    x = rnPart(:, 1) - rn(i-1, 1);
    y = rnPart(:, 2) - rn(i-1, 2);
    X = x/xBound;Y = y/yBound;
    b1 = b(i-1, :); b2 = b(j, :);

    %----Calculate The Cosh/Cos--------------------------------------------
    px = 2*pi*X;py = 2*pi*Y;
    sinpx = sin(px);cospx = cos(px);
    sinhpy = sinh(py);coshpy = cosh(py);
    rhoa = coshpy - cospx + a.^2;

    %----Calculate The Energy Between Two Dislocation----------------------
    E12 = - (b1(1).*b2(:, 1)+b1(2).*b2(:, 2)).*log(rhoa/Ra) - ...
    (b1(1)*b2(:, 1).*py.*sinhpy - b1(2)*b2(:, 2).*py.*sinhpy - ...
    b1(1)*b2(:, 2).*py.*sinpx - b1(2)*b2(:, 1).*py.*sinpx)./rhoa;

    Ener = Ener + sum(E12);
end


%----Calculate The Part Of Applied Stress----------------------------------
Ener = Ener - sum(appliedStress(6).*rn(:, 1).*rn(:, 3));

end
