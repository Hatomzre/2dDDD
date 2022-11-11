function vn = mobility(rn, fn, mob)
%This function calculates velocity using force

%----Initial Some Parameters-----------------------------------------------
N = size(rn, 1);
n = rn(1:N, 6:7);%This is glide plane normal
vn = fn*mob;

%----Checking velocity-----------------------------------------------------
for i = 1:N
    nMag = sqrt(n(i, 1)^2 + n(i, 2)^2);
    if nMag ~= 0
        nUnit = n(i, 1:2)/nMag;
        vn(i, :) = vn(i, :) - (vn(i, 1)*nUnit(1) + vn(i, 2)*nUnit(2))*nUnit;
    end
end

end