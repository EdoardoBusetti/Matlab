function [vector] = FacVectorize(num)
vector = zeros(1,num);
for i =1:num
    vector(i) = num;
    num = num-1;
end