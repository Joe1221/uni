function f = orientf(im, theta)
    imr = imrotate(im, theta, 'nearest');

    f = sum(abs(diff(mean(imr, 2))));
end
