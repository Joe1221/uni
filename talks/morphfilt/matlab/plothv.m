% plot h and v as intensities on a 2×n grid in row k
function plothv(h, v, n, k)
    subplot(n, 2, 2*(k-1) + 1)
    plot(1:length(h), h)
    subplot(n, 2, 2*(k-1) + 2)
    plot(1:length(v), v)
end
