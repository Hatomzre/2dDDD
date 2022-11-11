function rnNew = adjustByPBC(rn, xBoundtype, yBoundtype, xBound, yBound)
%This function checks periodic boundary condition

rnNew = rn;

%----Check The PBC in X direction------------------------------------------
if ~xBoundtype
    compL = floor(rn(:, 1)/xBound);
    rnNew(:, 1) = rn(:, 1) - xBound.*compL;
end

%----Check The PBC in Y direction------------------------------------------
if ~yBoundtype
    compL = floor(rn(:, 2)/yBound);
    rnNew(:, 2) = rn(:, 2) - yBound.*compL;
end

end