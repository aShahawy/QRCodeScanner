 %FCIS
 %Primary Function
 function QR()
  
  clc;
  clear;
  close all;
  
  choice = menu('Choose an Image', '1', '2', '3', '4', '5', '6', '7', '8'); %Choose an Image
  
  switch choice
        case 1
            filename = '1.1.bmp';
        case 2
            filename = '2.1.bmp';
        case 3
            filename = '3.1.bmp';
        case 4
            filename = '4.1.bmp';
        case 5
            filename = '5.1.bmp';
        case 6
            filename = '6.1.bmp';
        case 7
            filename = '7.1.bmp';
        case 8
            filename = '4.1.bmp';
        otherwise
            error('ERROR IN IMAGE SELECT');
    end %Choose an Image
    
    img = imread(filename);
    figure(1);
    imshow(img);
    title('Original Image');
    drawnow;

    img = isolateImage(img);
 end
 
 function imgIsolated = isolateImage(img)

    imgMask = im2bw(img, 0.08);
    imgMask = ~imgMask;
    
    label = bwlabel(imgMask, 8);
    clabels = label2rgb (label, 'hsv', 'k', 'shuffle');
    %subplot(3, 3, 2);
    figure(4);
    imshow(clabels);
    title('Sectionalized Mask');
    drawnow;
    
    sq = strel('square', 5);
    imgMask = imdilate(imgMask, sq);
    blobMeas = regionprops(imgMask, 'Area')
    blobMeas2 = regionprops(imgMask, 'BoundingBox')
    blobNum = size(blobMeas);
    blobArea = zeros(1,blobNum);
    for n = 1:blobNum
        blobArea(n) = blobMeas(n).Area;
    end

    [~, sortIndexes] = sort(blobArea, 'descend');
    bigestArea = sortIndexes(1);

    img = im2bw(img,graythresh (img, 'minimum'));
    bounding = ceil(blobMeas2(bigestArea).BoundingBox);
    x = [bounding(1)+1 bounding(1)+bounding(3)-1];
    y = [bounding(2)+1 bounding(2)+bounding(4)-1];
    img = img(y(1):y(2), x(1):x(2));
    img = bwareaopen(img,4);
    figure(6);
    imshow(img);
    title('Cleaned Image Mask');
    drawnow;
    imgIsolated = uint8(img);
end