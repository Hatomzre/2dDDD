%----THIS IS MAIN FILE FOR DISLOCATION DYNAMICS----------------------------

%----Periodic Poundary Condition-------------------------------------------
if ~xBoundtype && ~yBoundtype
    force = 'forceCut';
    energy = 'energyCut';
elseif ~xBoundtype
    force = 'forceXPBC';
    energy = 'energyXPBC';
else
    force = 'forceInf';
    energy = 'energyInf';
end

%----Set Output Directory--------------------------------------------------
simdir = ['D:/2DDDD/Results/', simName, '/'];
if ~exist(simdir, 'dir')
    mkdir(simdir);
end

%---- Property And Initial File Path---------------------------------------
propFile = [simdir, 'data.dat'];
restartFile = [simdir, 'restartInitial'];
save(restartFile);

%----Plot The Initial dislocation structure--------------------------------
figure(1)
plotDislocation(rn, xBound, yBound);
drawnow

%----Initial Parameters----------------------------------------------------
curstep = 1;
restart = 0;
strain = zeros(totalsteps, 1);
stress = zeros(totalsteps, 1);
velocity = zeros(totalsteps, 1);
Eofsystem = zeros(totalsteps, 1);
tSim = zeros(totalsteps, 1);
dt = dtSet;

%----Calculate The Velocity And Energyfor dislocations---------------------
vn = drndt(rn, appliedStress, mob, a, force, xBound, yBound, MU);
initialE = feval(energy, rn, a, appliedStress, xBound, ...
        yBound);

%----THIS IS THE MAIN LOOP FOR CALCULATION---------------------------------
while curstep <= totalsteps
    %----Calculate The Evolution By Different Methods----------------------
    [rnNew, vnNew, dt] = feval(integrator, rn, vn, dt, appliedStress, ...
        mob, a, conError, xBound, yBound, force, energy, dtMax, MU);

    %----Update Strain-----------------------------------------------------
    strain(curstep+1) = CalcuStrain(strain(curstep), rnNew, rn, ...
        xBound, yBound, relaxationFlag);

    %----Check The Periodic Boundary Conditions----------------------------
    rnNew = adjustByPBC(rnNew, xBoundtype, yBoundtype, xBound, yBound);
    [rn, vn] = fixPos(rnNew, rn, vnNew, a);

    %----Check The Applied Stress------------------------------------------
    appliedStress = CalcuStress(appliedStress, vn, dt, vfext, vth);

    %----Save The Results In N th Step-------------------------------------
    stress(curstep) = appliedStress(6);
    Eofsystem(curstep) = feval(energy, rn, a, appliedStress, xBound, ...
        yBound) - initialE;
    velocity(curstep) = sum(sum(abs(vn)))/size(vnNew, 1);
    %rn = rnNew;
    %vn = vnNew;
    curstep = curstep + 1;
    tSim(curstep) = tSim(curstep-1) + dt;

    %----Check Relaxation--------------------------------------------------
    if(stress(curstep-1) > 0 && ~relaxationFlag)
        figure(1)
        plotDislocation(rn, xBound, yBound);
        drawnow
        relaxationFlag = 1;
    end

    %----Check Quit--------------------------------------------------------
    if(strain(curstep) > 0.01)
        figure(1)
        plotDislocation(rn, xBound, yBound);
        drawnow
        break;
    end

    %----Plot Dislocation System-------------------------------------------
    if(mod(curstep, plotF) == 0)
        figure(1)
        plotDislocation(rn, xBound, yBound);
        drawnow
    end

    if(mod(curstep, restartF) == 0)
        restartFile = [simdir, 'restartWhen', int2str(restart)];
        save(restartFile);
        rnFile = [simdir, 'rnWhen', int2str(restart), 'dat'];
        save(rnFile, 'rn', '-ASCII');
        restart = restart + 1;
    end
end