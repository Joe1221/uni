function im = imbtophat (im, se)
    im = imclose(im, se) - im;
end
