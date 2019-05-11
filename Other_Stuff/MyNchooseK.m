function [combinations] = MyNchooseK(n,k)

VecN = 1:n;
VecK = 1:k;
VecN_K = 1:(n-k);

%Check that k is smaller or equal to n
if k > n
    error('k must be smaller or equal than n');
end


%Simplify the numerato with the largest of the two vectors that we have at
%the denominator and then save the new Numerator and Denominator
if k > (n-k)
    SimpleVector = VecN(~ismember(VecN, VecK));
    SimpleVector = sort(SimpleVector);
    Numerator = SimpleVector;
    Denominator = sort(VecN_K);
else
    SimpleVector = VecN(~ismember(VecN, VecN_K));
    SimpleVector = sort(SimpleVector);
    Numerator = SimpleVector;
    Denominator = sort(VecK);
    
end

%Check if we can simpify other elements of the numerator with elements of
%the denominator while still mainteining integers
for i=1:length(Denominator)
    for j=1:length(Numerator)
        if rem(Numerator(j),Denominator(i))==0
            Numerator(j) = Numerator(j)/Denominator(i);
            Denominator(i) = 1;
            break
        end
    end
end

%After we have done all the simplifications calculate the value for both
%the numerator and denominator of the equation and then do the calculations
%necessary to get the combinations number
combinations = prod(Numerator)/prod(Denominator);




