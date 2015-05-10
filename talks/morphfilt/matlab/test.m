function test (impath, s)
    im = rgb2gray(imread(impath));

    subplot(4,3,1), imshow(im, 'InitialMagnification', 'fit');
    subplot(4,3,4), imshow(imdilate(im, s));
    subplot(4,3,5), imshow(imerode(im, s));
    subplot(4,3,7), imshow(imopen(im, s));
    subplot(4,3,8), imshow(imclose(im, s));
    subplot(4,3,10), imshow(im - imopen(im, s)); % white-top-hat
    subplot(4,3,11), imshow(imclose(im, s) - im); % black-top-hat
    im2 = im - imopen(im, s);
    im3 = imclose(im, s) - im;
    subplot(4,3,12), imshow(real(im2 > 5)); % black-top-hat
    subplot(4,3,6), imshow(imclose(im3, s) - im3); % black-top-hat
    subplot(4,3,3), imshow(im2 - imopen(im2,s)); % black-top-hat
    %subplot(4,3,3), imshow(real(im > 130)); % black-top-hat
    im2
    %spy(im2)
end
