function imres = my_imdilate (im, s)
    imres = zeros(size(im));

    neighbors = getneighbors(s);
    for i = 1:size(neighbors, 1)
        %imshift = circshift(im, neighbors(i,:));
        imshift = padshift(im, neighbors(i,:), 0);
        imres = max(imres, imshift);
    end
end
