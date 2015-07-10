%im = imread("images/scanned/scan-300dpi-light.png");
%s = strel('square', 10)

s = strel('square', 4);
for k = logspace(2, 4, 10)
    disp(k);
    fflush(stdout);
    m = uint8(randi([0 255], round(k)));

    f = @() imdilate(m, s);
    g = @() my_imdilate(m, s);

    timeit(f)
    timeit(g)
end



