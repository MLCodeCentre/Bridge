function y = moveRMS(x,window)

% moving rsm.
x_length = size(x,1);
y = zeros(size(x));

for i = 1:size(x,1)
   if i <= window
       window_start = 1;
       window_end = window_start + window;
   elseif i > x_length - window
       window_start = i;
       window_end = x_length;
   else
       window_start = i - window;
       window_end = i + window;
   end
   window_data = x(window_start:window_end);
   RMS = sqrt(sum(window_data.^2)/(2*window));
   y(i) = RMS;
end