function fn = forceCut(rn, appliedStress, a, xBound, yBound, ~)
%This function calculates the force for each dislocation in PBCs

%----Initial Some Parameters-----------------------------------------------
N = size(rn, 1);
fn = zeros(9*N, 2);
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

%----Calculating Force For i-1 th dislocation------------------------------
for i = 2:N+1
    j = i:9*N;
    rnPart = rnPBC(j, :);
    x = rnPart(:, 1) - rn(i-1, 1);
    y = rnPart(:, 2) - rn(i-1, 2);
    b1 = b(i-1, :); b2 = b(j, :);

    %----Force Calculated by Peach-Koehler Formula-------------------------
    gx=b1(1).*(b2(:,1).*x.*(x.^2+a^2-y.^2)+b2(:,2).*y.*(x.^2-a^2-y.^2));
    gy=b1(1).*(b2(:,1).*y.*(3.*x.^2+y.^2+3*a^2)-b2(:,2).*x.*(x.^2-y.^2+a^2));

    gx=(gx+b1(2).*(-b2(:,1).*y.*(y.^2-x.^2+a^2)+b2(:,2).*x.*(3.*y.^2+ ...
        x.^2+3*a^2)))./(y.^2+x.^2+a^2).^2;
    gy=(gy+b1(2).*(b2(:,1).*x.*(y.^2-x.^2-a^2)+b2(:,2).*y.*(y.^2- ...
        x.^2+a^2)))./(y.^2+x.^2+a^2).^2;

    %----Force For i-1th Dislocation---------------------------------------
    fn(i-1, :) = fn(i-1, :) - [sum(gx), sum(gy)];

    %----Force For i-N th Dislocation--------------------------------------
    fn(j, :) = fn(j, :) + [gx, gy];
end

%----Applied Stress For Dislocations---------------------------------------
fn(N+1:9*N, :) = [];
fn = fn + [appliedStress(6)*b(1:N, 1)+appliedStress(2)*b(1:N, 2)+...
    appliedStress(4)*b(1:N, 3) , -(appliedStress(1)*b(1:N, 1)+ ...
    appliedStress(6)*b(1:N, 2)+appliedStress(5)*b(1:N, 3))];
end