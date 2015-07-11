function imres = my_imerode (im, se)
    imres = zeros(size(im), 'uint8');

    for se = getsequence(se)'
        imres(:) = intmax('uint8');
        for nb = getneighbors(se)'
            %imshift = circshift(im, neighbors(i,:));
            imshift = padshift(im, nb, intmax('uint8'));
            imres = min(imres, imshift);
        end
        im = imres;
    end
end
