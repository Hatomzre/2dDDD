function [rn, vn] = fixPos(rnNew, rn, vn, a)
%This function fixs dislocations which are too close

%----Prepare Some Parameters-----------------------------------------------
NofD = size(rn, 1);
flag = zeros(NofD, 1);

for i = 2:NofD
    j = i:NofD;
    rn1 = rn(j, :);
    rn2 = rnNew(j, :);

    %----Get Position Change-----------------------------------------------
    x1 = rn1(:, 1) - rn(i-1, 1);y1 = rn1(:, 2) - rn(i-1, 2);
    x2 = rn2(:, 1) - rnNew(i-1, 1);y2 = rn2(:, 2) - rnNew(i-1, 2);
    dr1 = x1.^2 + y1.^2;
    dr2 = x2.^2 + y2.^2;

    %----If More Close, Fixing---------------------------------------------
    near_singularities = find((dr1 <= a).*(dr2 < dr1));
    if ~isempty(near_singularities)
        flag(i-1) = 1;
        flag(near_singularities+i-1) = 1;
    end
end

rn = rnNew.*(flag == 0) + rn.*(flag == 1);
vn = vn.*(flag == 0);
end