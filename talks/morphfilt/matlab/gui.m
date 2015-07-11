function gui

    ssize = [11, 11];
    se = false(ssize);
    se(ceil(end/2), ceil(end/2)) = true;

    sef = figure(1);
    colormap([0 0 0; 1 1 1]);
    seh = image(se);
    sea = gca;

    set(sea, 'XTick', 1:ssize(2));
    set(sea, 'XTickLabel', (1:ssize(2)) - ceil(ssize(2)/2));
    set(sea, 'YTick', 1:ssize(1));
    set(sea, 'YTickLabel', (1:ssize(1)) - ceil(ssize(1)/2));
    axis image

    set(sef, 'UserData', false)

    set(sef, 'WindowButtonDownFcn', @(s, e) smousebutton(true));
    set(sef, 'WindowButtonUpFcn', @(s, e) smousebutton(false));
    set(sef, 'WindowButtonMotionFcn', @(s, e) smousemove());

    function smousebutton (bool)
        set(sef, 'UserData', bool)
        smousemove();
    end

    function smousemove ()
        if ~get(sef, 'UserData')
            return
        end
        pos = round(get(sea, 'CurrentPoint'));
        x = pos(1,1);
        y = pos(1,2);
        switch get(sef, 'SelectionType')
            case 'normal'
                setc = true;
            case 'alt'
                setc = false;
        end
        if (se(y,x) == setc)
            return
        end
        se(y,x) = setc;
        set(seh, 'CData', se);
        updateimage();
    end

    function updateimage ()
        sel = strel('arbitrary', se);
        set(imh(3), 'CData', imerode  (im, sel));
        set(imh(4), 'CData', imdilate (im, sel));
        set(imh(5), 'CData', imopen   (im, sel));
        set(imh(6), 'CData', imclose  (im, sel));
        set(imh(7), 'CData', imwtophat(im, sel));
        set(imh(8), 'CData', imbtophat(im, sel));
    end

    %im = rgb2gray(imread('saturn.png'));
    %im = imread('snowflakes.png');
    %im = 255*uint8(imread('blobs.png'));
    im = imread('cameraman.tif');

    imf = figure(2);
    imh = zeros(4,2);

    titles = {'original', '', 'erosion', 'dilation', 'opening', 'closing', 'white tophat', 'black tophat'};
    for i = 1:8
        subplot(4,2,i), imh(i) = image(im);
        title(titles{i});
        axis image;
    end



end
