function imres = my_imdilate (im, se)
    imres = zeros(size(im), 'uint8');

    for se = getsequence(se)'
        imres(:) = intmin('uint8');
        for nb = getneighbors(se)'
            %imshift = circshift(im, -nb);
            imshift = padshift(im, -nb, intmin('uint8'));
            imres = min(imres, imshift);
        end
        im = imres;
    end
end
