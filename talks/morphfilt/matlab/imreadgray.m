function im = imreadgray (path)
    im = imread(path);
    if ndims(im) == 3
        im = rgb2gray(im);
    end
    if isa(im, 'logical')
        im = intmax('uint8') * uint8(im);
    end
end
