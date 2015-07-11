%im = imread("images/scanned/scan-300dpi-light.png");
%s = strel('square', 10)

s = strel('square', 2);

n = 10;
dims = round(linspace(200, 3000, n));
t = zeros(n, 2);

for k = 1:n
    m = uint8(randi([0 255], dims(k)));

    f = @() imdilate(m, s);
    g = @() my_imdilate(m, s);

    t(k,:) = [timeit(f), timeit(g)];
end
plot(dims, t)
legend('imdilate()', 'my_imdilate()')



