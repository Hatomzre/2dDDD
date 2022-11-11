function plotDislocation(rn, xBound, yBound)
% This function plots dislocation system
%   rn(:, 1) --- position in X
%   rn(:, 2) --- position in Y
%   rn(:, 3:5) --- Burgers Vector

%----Number of dislocations------------------------------------------------
N = size(rn, 1);

%----Get Burgers Vectors---------------------------------------------------
b = zeros(N, 3);
b(1:N, 1:3) = rn(:, 3:5);

%----Draw Simulation Box---------------------------------------------------
plot([0 1 1 0 0]*xBound, [0 0 1 1 0]*yBound);
hold on;

for i = 1:N
    %----Plot Pure Edge Dislocation----------------------------------------
    if ~b(i, 3)
        b_linex=[rn(i, 1)-b(i, 1),rn(i, 1)+b(i, 1)];
        b_liney=[rn(i, 2)-b(i, 2),rn(i, 2)+b(i, 2)];
        n_linex=[rn(i, 1),rn(i, 1)-b(i, 2)*1.5];
        n_liney=[rn(i, 2),rn(i, 2)+b(i, 1)*1.5];
        p1 = plot (n_linex, n_liney, 'k');  set(p1, 'LineWidth', 2);
        p2 = plot (b_linex, b_liney, 'k');  set(p2, 'LineWidth', 2);
    %----Plot Mixed or Screw Dislocation-----------------------------------
    elseif b(i, 3) > 0
        plot(rn(i, 1), rn(i, 2), '.b');
    else
        plot(rn(i, 1), rn(i, 2), '.r');
    end
end

hold off
axis equal
xlim([0, xBound]);
ylim([0, yBound]);

xlabel('X');
ylabel('Y');

grid on;

title('Dislocations');

end