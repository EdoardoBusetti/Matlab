close
clear
clc

%Counters for the number of winnings in each case
results_Switch = 0;
results_NO_Switch = 0;
number_of_iterations = 1000;

for i = 1:number_of_iterations
        %generating the door with the prize at random
    Prize = randi(3,1);

        %Selecting the first door at random
    first_try = randi(3,1);
        %Monty reveals a door choosing between the door/doors you didn't choose
        %that DO NOT have the prize in them.
    door_revealing = setdiff(1:3, [first_try,Prize]);
         %If you guessed on your first try, Monty can choose to reveal one
         %of the two remaining doors

    if length(door_revealing) ~= 1
        remaining_door = randi(2,1);
        door_revealing = door_revealing(remaining_door);
    end
        % The second try does not include the door that was just opened,
        % nor the first door (since you are switching )

    second_try = setdiff(1:3, [first_try,door_revealing]);
        %If you win +1 in results_switch -> Counter of winnings for the
        %Switch option
    if second_try == Prize
        results_Switch = results_Switch + 1;
    end

        %If you win +1 in results_NO_Switch -> Counter of winnings for the
        %NOSwitch option
    if first_try == Prize
        results_NO_Switch = results_NO_Switch +1;
    end
end

%Display the results of the simulations
fprintf('Number of tries: %d \n',number_of_iterations)

fprintf('Percentage of wins with Switch: %f \n',results_Switch/number_of_iterations)

fprintf('Percentage of wins with NO Switch: %f \n',results_NO_Switch/number_of_iterations)
