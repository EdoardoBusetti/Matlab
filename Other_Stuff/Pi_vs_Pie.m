close
clear
clc

A = [0 0];
B = [1 0];
C = [1 1];
D = [0 1];
center = [0.5 0.5];

numtries = 1000000;


inside_points = 0;
outside_points = 0;
for i=1:numtries
    x_point = rand;
    y_point = rand;
    point = [x_point y_point];
    if norm(point-center) < 0.5
        inside_points = inside_points + 1;
    else
        outside_points = outside_points +1;
    end
end

pi = inside_points*4/numtries;
fprintf('Estimation of pi: %f',pi);