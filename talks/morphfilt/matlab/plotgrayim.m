function plotgrayim (im)
    imagesc(im);
    axis image;

    colormap('gray')
    caxis([0, intmax('uint8')])
end
