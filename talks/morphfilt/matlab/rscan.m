function rscan (im, varargin)
    optargs = {
        300, ... % dpi
        [10, 10, 10, 10], ... % target margins in mm [left, top, right, bottom]
        10, ... % rotation range in degrees
    };
    optargs(1:length(varargin)) = varargin;
    [dpi, margins, rotrange] = optargs{:};

    if ~ismatrix(im) || ~isa(im, 'uint8')
        error('morphfilt:rscan:WrongInput', 'Need a uint8 grayscale image');
    end

    % cook inputs
    margins = margins / 10 * (dpi / 2.54);

    % === remove background illumination (inverts image)

    b = strel('square', (dpi / 300) * 10);
    im = imclose(im, b) - im;

    % === adjust orientation

    f = @(theta) -orientf(im, theta);
    theta = fminbnd(f, -rotrange, rotrange);
    im = imrotate(im, theta, 'bicubic');

    % === crop (currently dirty)

    h = mean(im, 1) / 255;
    v = mean(im, 2)' / 255;

    h = imopen([zeros(1,100), h, zeros(1,100)], strel('line', 100, 0));
    h = h(101:end-100);
    h = imclose(h, strel('line', 100, 0));
    v = imopen([zeros(1,100), v, zeros(1,100)], strel('line', 25, 0));
    v = v(101:end-100);
    v = imclose(v, strel('line', 100, 0));
    v = find(v > 0.5e-3);
    h = find(h > 0.5e-3);
    rect = [h(1) - margins(1), v(1) - margins(2), h(end) + margins(3), v(end) + margins(4)];
    rect = [rect(1:2), rect(3:4) - rect(1:2)];

    im = imcrop(im, rect);

    imwrite(im, 'a.jpg');
end
