function Ener = energyCut(rn, a, appliedStress, xBound, yBound)
%This function calculates energy of the dislocation system in PBCs

%----Prepare Some Parameters-----------------------------------------------
N = size(rn, 1);
Ener = 0;
Ra = 1E16;
rnPBC = zeros(9*N, 7);
cur = [0 -1 1];


%----Get The Image Dislocations--------------------------------------------
for i = 1:3
    for j = 1:3
        rnPBC(((i-1)*3+j-1)*N+1:((i-1)*3+j)*N, :) = ...
        [rn(1:N, 1)+cur(i)*xBound, rn(1:N, 2)+cur(i)*yBound, rn(1:N, 3:7)];
    end
end

%----Get Burgers Vectors---------------------------------------------------
if N ~= 0
    b(1:9*N, 1:3) = rnPBC(1:9*N, 3:5);
end

%---Calculating The Energy For System--------------------------------------
for i = 2:N
    j = [i:N, i+N:2*N, i+2*N:3*N, i+3*N:4*N, i+4*N:5*N, i+5*N:6*N, ...
        i+6*N:7*N, i+7*N:8*N, i+8*N:9*N];
    rnPart = rnPBC(j, :);
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