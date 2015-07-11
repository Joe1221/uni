function im = imwtophat (im, se)
    im = im - imopen(im, se);
end
