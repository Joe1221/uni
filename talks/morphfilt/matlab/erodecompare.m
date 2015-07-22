% compare imerode vs my_imerode
function erodecompare

    % visual comparison
    % =================

    im = imreadgray('images/abstract.jpg');
    se = strel('square', 5);

    figure(1)
    colormap('gray')
    caxis([0, intmax('uint8')])

    r1 = imerode(im, se);
    r2 = my_imerode(im, se);

    my_subplot(2, 2, 1);
    plotgrayim(im);
    my_subplot(2, 2, 3);
    plotgrayim(r1);
    my_subplot(2, 2, 4);
    plotgrayim(r2);

    my_subplot(2, 2, 2);

    r1 = int16(r1);
    r2 = int16(r2);

    r = (r1 - r2) + int16(intmax('uint8') / 2);

    plotgrayim(r);


    % performance comparison
    % ======================
    % Even though `timeit` is used, there seem to be slight discrepancies
    % across multiple runs.

    m = 15; % structuring element size (m × m)
    n = 10; % number of measurements
    npix = [1e3, 3e6]; % square image size range (total number of pixels)

    % use non-composed structuring element
    %s = strel('square', m);
    s = strel('arbitrary', ones(m));

    dims = round(sqrt(linspace(npix(1), npix(2), n)));
    t = zeros(n, 2);

    for k = 1:n
        fprintf('Timing, size: %d × %d\n', dims(k), dims(k));
        m = randi([0, 255], dims(k), 'uint8');

        f = @() imerode(m, s);
        g = @() my_imerode(m, s);

        t(k,:) = [timeit(f), timeit(g)];
    end

    figure(2)
    plot(dims.^2, t, 'Marker', '.')
    legend('imerode()', 'my_imerode()')
    %title(sprintf('erosion, %d x %d square', m, m))
    %spy(r)
end
