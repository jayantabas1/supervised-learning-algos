function [d] = distance(x,y)
     lgh = length(x);
     sum = 0;
     for i = 1: lgh
         sum = sum + (x(i)-y(i))^2;
     end
    d = sqrt(sum);
end