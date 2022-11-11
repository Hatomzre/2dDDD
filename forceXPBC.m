function fn = forceXPBC(rn, appliedStress, a, xBound, yBound, ~)
%This function calculates the force for each dislocation in X PBC

%----Initial Some Parameters-----------------------------------------------
N = size(rn, 1);
fn = zeros(N, 2);

%----Get Burgers Vectors---------------------------------------------------
if N ~= 0
    b(1:N, 1:3) = rn(1:N, 3:5);
end
%----Calculating Force For i-1 th dislocation------------------------------
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

    %----Force Calculated by Peach-Koehler Formula-------------------------
    gx=b1(1).*(b2(:,1).*sinpx.*(rhoa-py.*sinhpy)+b2(:,2).*py.*(cospx.*(coshpy+a^2)-1));
    gy=b1(1).*(b2(:,1).*(2.*sinhpy.*rhoa-py.*(coshpy.*(cospx-a^2)-1))- ...
        b2(:,2).*sinpx.*(rhoa-py.*sinhpy));

    gx=(gx+b1(2).*(-b2(:,1).*py.*(cospx.*(coshpy+a^2)-1)+b2(:,2).*sinpx.*(...
        rhoa+py.*sinhpy)))./rhoa.^2;
    gy=(gy+b1(2).*(b2(:,1).*sinpx.*(rhoa-py.*sinhpy)-b2(:,2).*py.*(...
        coshpy.*(cospx-a^2)-1)))./rhoa.^2;

    %----Force For i-1th Dislocation---------------------------------------
    fn(i-1, :) = fn(i-1, :) - [sum(gx), sum(gy)];

    %----Force For i-N th Dislocation--------------------------------------
    fn(j, :) = fn(j, :) + [gx, gy];
end

%----Applied Stress For Dislocations---------------------------------------
fn = fn + [appliedStress(6)*b(:,1)+appliedStress(2)*b(:,2)+...
    appliedStress(4)*b(:,3) , -(appliedStress(1)*b(:,1)+ ...
    appliedStress(6)*b(:,2)+appliedStress(5)*b(:,3))];
end