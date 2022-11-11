function Ener = energyInf(rn, a, appliedStress, ~, ~)
%This function calculates energy of the dislocation system

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
    b1 = b(i-1, :); b2 = b(j, :);

    %----Calculate The distance--------------------------------------------
    rhoa = x.^2 + y.^2 + a.^2;

    %----Calculate The Energy Between Two Dislocation----------------------
    E12 = - (b1(1).*b2(:, 1)+b1(2).*b2(:, 2)).*log(rhoa/Ra)./2 - ...
    (b1(2).*x-b1(1).*y).*(b2(:, 2).*x-b2(:, 1).*y)./rhoa;
    Ener = Ener + sum(E12);
end

%----Calculate The Part Of Applied Stress----------------------------------
Ener = Ener - sum(appliedStress(6).*rn(:, 1).*rn(:, 3));

end