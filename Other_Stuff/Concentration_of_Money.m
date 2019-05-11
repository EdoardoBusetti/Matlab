close
clear
clc

people = [1:1:100];

money = ones(1,length(people))*100;

p = 0.5;

numtries = 1000000;

for i=1:numtries
    first_person = datasample(people,1);
    
    people_2 = people(find(people~=first_person));

    second_person = datasample(people_2,1);
    
    if rand()< p
        money(first_person) = money(first_person) + 1;
        money(second_person) = money(second_person) - 1;
        if money(second_person) == 0
            people = people(find(people~=second_person));
        end
    else
        money(first_person) = money(first_person) + 1;
        money(second_person) = money(second_person) - 1;
                if money(first_person) == 0
            people = people(find(people~=first_person));
                end
    end
end

hist(money,100);

