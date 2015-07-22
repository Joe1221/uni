function rscan (im, varargin)
    optargs = {
        300,               ... % dpi: image resolution, dots per inch
        [10, 10, 10, 10],  ... % margins: target margins in mm [left, top, right, bottom]
        2,                 ... % bgilsize: background illumination filter (square) size in mm
        [-10, 10],         ... % rotrange: rotation range in degrees
        [10, 1.9],         ... % cropfuzz: max structures in mm [h, v] to ignore when cropping
                           ... %           sensible values: [max margin par width + ε, lineheight - ε]
        [0.02, 0.02],      ... % croptopfrac: top significant fraction for crop thresholds
        [0.10, 0.10],      ... % croptopthresh: crop thresholds in % [h, v]
        0.10,               ... % bwthresh: b/w threshold in %
    };
    optargs(1:length(varargin)) = varargin;
    [dpi, margins, bgilsize, rotrange, cropfuzz, croptopfrac, cropthresh, bwthresh] = optargs{:};

    if ~ismatrix(im) || ~isa(im, 'uint8')
        error('morphfilt:rscan:WrongInput', 'Need a uint8 grayscale image');
    end

    % convert mm to px using dpi
    function px = mm2px (mm)
        px = round((mm / 10) .* (dpi / 2.54));
    end

    % cook inputs
    margins = mm2px(margins);
    cropfuzz = mm2px(cropfuzz);
    bgilsize = mm2px(bgilsize);

    imwrite(im, 'out/0_orig.png');

    % === remove background illumination (inverts image btw)
    % ========================================

    fprintf('removing background illumination ...\n')
    b = strel('square', bgilsize);
    im = imclose(im, b) - im; % black top hat

    imwrite(im, 'out/1_bth.png');

    % === adjust orientation
    % ========================================

    function f = frectified(im, theta)
        imr = imrotate(im, theta, 'nearest');
        f = norm(abs(diff(mean(imr, 2))));
    end

    fprintf('align by rotating ...\n')
    f = @(theta) -frectified(im, theta);
    theta = fminbnd(f, rotrange(1), rotrange(2));
    im = imrotate(im, theta, 'bicubic');

    imwrite(im, 'out/2_rot.png');

    % === crop image
    % ========================================

    imb = imclose(im, strel('rectangle', flip(cropfuzz)));
    imwrite(imb, 'out/3_cropfuzz.png');

    % compute the mean for a top (i.e. largest elements) fraction frac of numbers
    % of a matrix im along dimension dim
    function x = meantoprange(im, dim, frac)
        im = shiftdim(im, dim - 1);
        x = flip(sort(im));
        x = x(1:round(frac*end), :);
        x = mean(x, 1);
    end

    % morphological opening on one-dimensional data x using block of size l
    % important: data along boundary is intentionally discarded
    function x = removepeaks(x, l)
        pad = zeros(1, l);
        x = imopen([pad, x, pad], strel('line', l, 0));
        x = x(l + 1 : end - l);
    end

    % plot h and v as intensities on a 2×n grid in row k
    function plothv(h, v, n, k)
        subplot(n, 2, 2*(k-1) + 1)
        plot(1:length(h), h)
        subplot(n, 2, 2*(k-1) + 2)
        plot(1:length(v), v)
    end

    fprintf('cropping ...\n')

    h = meantoprange(imb, 1, croptopfrac(1)) / double(intmax('uint8'));
    v = meantoprange(imb, 2, croptopfrac(2)) / double(intmax('uint8'));
    plothv(h, v, 2, 1)

    h = removepeaks(h, cropfuzz(1));
    v = removepeaks(v, cropfuzz(2));
    plothv(h, v, 2, 2)

    h = find(h > cropthresh(1));
    v = find(v > cropthresh(2));
    rect = [ ...
        h(1) - margins(1), v(1) - margins(2), ...
        h(end) - h(1) + 2*margins(3), v(end) - v(1) + 2*margins(4) ...
    ];

    im = imcrop(im, rect);
    imwrite(im, 'out/4_cropped.png');

    % === thresholding
    % ========================================

    im = intmax('uint8') * (1 - uint8(im > bwthresh * intmax('uint8')));

    imwrite(im, 'out/5_fin.png');
end
