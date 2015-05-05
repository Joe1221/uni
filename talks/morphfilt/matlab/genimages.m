im = phantom(80);

imwrite(im, 'images/phantom80.png');


se = strel('rectangle', [3,3]);
imwrite(im, 'images/phantom80.png');
imwrite(imerode(im, se), 'images/phantom80_erode.png');
imwrite(imdilate(im, se), 'images/phantom80_dilate.png');



