function peakToPeak(x,p)

peaks = [];
peak_indices = [];
x_length = size(x,1);

for i = 1:x_length
    if i > 1 && i < x_length
        if x(i) > x(i-1) && x(i) > x(i+1)
            if isempty(peak_indices) || i - p > peak_indices(end)
                peaks = [peaks, x(i)];
                peak_indices = [peak_indices, i];
            end
        end
    end
end

pp = spline(peak_indices,peaks,1:x_length);
plot(pp)