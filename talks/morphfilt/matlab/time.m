%im = imread("images/scanned/scan-300dpi-light.png");
%s = strel('square', 10)


n = 3;

m = 20;
%sm = logical(randi([0, 1], [m, m], 'uint8'));
%s = strel('arbitrary', sm)
s = strel('arbitrary', ones(m));

dims = round(sqrt(linspace(1e3, 5e6, n)));
t = zeros(n, 2);

for k = 1:n
    fprintf('Timing, size: %d × %d\n', dims(k), dims(k));
    m = randi([0, 255], dims(k), 'uint8');

    f = @() imerode(m, s);
    g = @() my_imerode(m, s);

    t(k,:) = [timeit(f), timeit(g)];
end

plot(dims.^2, t)
legend('imerode()', 'my_imerode()')
title(sprintf('erosion, %d x %d square', m, m))




