function [prob] = ants(num_iter)

%Initializing the 3 ants
ant = NaN(1,3);

%Setting the counters for the numer of collision and no collisions to 0
No_collision = 0;
Collision = 0;

%doing num_iter simulations
for i=1:num_iter
    for j=1:3
        %The ants can go either to right(0) or left(1)
        ant(j) = randi([0,1]);
    end
   
    Z = sum(ant);
    %The ants won't collide when they all pick the same directions, that is
    %when the sum of all the values for the ants is either 0(3 right) or 3
    %(3 lefts)
    if Z == 3 || Z == 0
        %If they don't collide, add 1 to the No_collisions counter
        No_collision = No_collision + 1;
        
    else
        Collision = Collision + 1;
    end
end

%The probability of not colliding is given by the cumber of non collions
%divided by the number of iterations of the simulation
prob = No_collision/num_iter;
        