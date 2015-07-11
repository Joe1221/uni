function imres = my_imerode (im, s)
    imres = zeros(size(im), 'uint8');
    imres(:) = intmax('uint8');

    neighbors = getneighbors(s);
    for i = 1:size(neighbors, 1)
        %imshift = circshift(im, neighbors(i,:));
        imshift = padshift(im, neighbors(i,:), intmax('uint8'));
        imres = min(imres, imshift);
    end
end
