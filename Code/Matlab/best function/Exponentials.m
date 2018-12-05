function y = Exponentials(thetas, t_range, data, n)

y = zeros(size(data));

for i = 1:n
   theta = thetas(((i-1)*n)+1:((i-1)*n)+4);
   y = y + genExp(t_range,theta);
end
 
end