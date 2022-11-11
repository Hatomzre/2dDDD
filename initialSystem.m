function rn = initialSystem(numofDislocation)
% This function give the initial structure of dislocation system

%----About Box-------------------------------------------------------------
boxsize = 50;

%----Initial rn------------------------------------------------------------
rn = zeros(numofDislocation, 7);

%----Initial The Position of Dislocation-----------------------------------
for i = 1:numofDislocation
    rn(i, 1:2) = boxsize*rand(1, 2);
    for j = 1:i-1
        %----No The Same Position------------------------------------------
        while rn(i, 1) == rn(j, 1) && rn(i, 2) == rn(j, 2)
            rn(i, :) = boxsize*rand(1, 2);
        end
    end
end

%----Initial The Burgers Vector For Dislocation----------------------------
rn(1:numofDislocation/2, 3) = 1;
rn(numofDislocation/4+1:numofDislocation/2, 3) = -1;
rn(numofDislocation/2+1:numofDislocation, 4) = 1;
rn(3*numofDislocation/4+1:numofDislocation, 4) = -1;

%----Initial Glide Plane Normal For Dislocation----------------------------
rn(1:numofDislocation/2, 7) = 1;
rn(numofDislocation/2+1:numofDislocation, 6) = 1;

end