im = phantom(80);

imwrite(im, 'images/phantom80.png');

se = strel('rectangle', [3,3]);
imwrite(im, 'images/phantom80.png');
imwrite(imerode(im, se), 'images/phantom80_erode.png');
imwrite(imdilate(im, se), 'images/phantom80_dilate.png');

im = imread('images/worms80.png');
se = strel('diamond', 1);
imwrite(imerode(im, se), 'images/worms80_erode.png');
imwrite(imdilate(im, se), 'images/worms80_dilate.png');
imwrite(imopen(im, se), 'images/worms80_open.png');
imwrite(imclose(im, se), 'images/worms80_close.png');

im = imread('images/fish15.png');
se = strel('rectangle', [2, 2]);
imwrite(imerode(im, se), 'images/fish15_erode.png');
imwrite(imdilate(im, se), 'images/fish15_dilate.png');
imwrite(imopen(im, se), 'images/fish15_open.png');
imwrite(imclose(im, se), 'images/fish15_close.png');

im = imread('images/leopard250.png');
se = strel('rectangle', [10, 10]);
imwrite(real(im > 130), 'images/leopard250_thres.png');
imwrite(imopen(im, se), 'images/leopard250_open.png');
imwrite(imclose(im, se), 'images/leopard250_close.png');
imwrite(im - imopen(im, se), 'images/leopard250_wtophat.png');
imwrite(imclose(im, se) - im, 'images/leopard250_btophat.png');
imwrite(real(im - imopen(im, se) > 5), 'images/leopard250_wtophat_thres.png');
imwrite(real(imclose(im, se) - im < 60), 'images/leopard250_btophat_thres.png');

im = imread('images/chair.png');
se = ones(5,5);
imwrite(imfilter(im,se/25), 'images/chair_linmedian.png');
imwrite(ordfilt2(im,13,se), 'images/chair_morphmedian.png');

im = imread('images/rects.png');
s1 = strel('arbitrary', [0, 0, 0; 0, 1, 1; 0, 1, 0]);
s2 = strel('arbitrary', [0, 1, 1; 1, 0, 0; 1, 0, 0]);
imwrite(min(imerode(im, s1), imerode(imcomplement(im),s2)), 'images/rects_hitmiss.png');
