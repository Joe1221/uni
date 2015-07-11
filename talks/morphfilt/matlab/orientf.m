function f = orientf(im, theta)
    imr = imrotate(im, theta, 'nearest');

    f = norm(abs(diff(mean(imr, 2))));
end
