function strainNew = CalcuStrain(strain, rnNew, rn, xBound, yBound, ...
    Flag)
%This function calculates the strain in tn-tn+1

%----Prepare Some Parameters-----------------------------------------------
N = size(rn, 1);
strainNew = 0;

%----Get Burgers Vectors---------------------------------------------------
if N ~= 0
    b(1:N, 1:3) = rn(1:N, 3:5);
end

%----Calculating strain----------------------------------------------------
if Flag
    strainNew = strain + sum(b(:, 1).*(rnNew(:, 1)-rn(:, 1)))/(2*xBound*yBound);
    strainNew = strainNew - sum(b(:, 2).*(rnNew(:, 2)-rn(:, 2)))/(2*xBound*yBound);
end

end