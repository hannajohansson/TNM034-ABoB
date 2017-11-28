% PART 2: Face alignment
    % Find eyes using eye map 
        % Chrominance
        % Luminance 
        % Combine them to one map 
    % Mouthmap

function faceAlignment(editedImage, faceMask)

load ('db0Images');
load ('db1Images');
load ('db1Faces');


image = editedImage;

%{
currentFace = 11;
image = db1Images{currentFace};
faceMask = db1Faces{currentFace};
%image = db0Images{2};
%}

%Convert to colorspace YCbCr
iycbcr = rgb2ycbcr(image); 

%----------------------------------------------------------------
%                 faceMask
%----------------------------------------------------------------
% Make faceMask binary
faceMaskBin = im2bw(faceMask, 0.01);    %use imbinarize instead of im2bw
SEr = strel('disk', 30, 8); % radius = 10, n(number of segments) = 8
SDil = strel('disk', 6, 8); % radius = 10, n(number of segments) = 8
faceMask = imerode(imdilate(faceMaskBin, SDil), SEr);

%----------------------------------------------------------------
%                 eyes and mouth detection
%----------------------------------------------------------------
finalEyeMap = eyeMap(image, iycbcr, faceMask);
finalMouthMap = mouthMap(image, iycbcr, faceMask);

%----------------------------------------------------------------
%                 plot images, use uint8 to plot images
%----------------------------------------------------------------
%{
figure;
subplot(2,2,1);
imshow(image);
title('image'); 

subplot(2,2,2);
imshow(faceMask);
title('faceMask'); 

subplot(2,2,3);
imshow(finalEyeMap);
title('finalEyeMap');
 
subplot(2,2,4);
imshow(finalMouthMap);
title('finalMouthMap'); 
%}

%----------------------------------------------------------------
%                 find position of objects
%----------------------------------------------------------------
%bwlabel --> label all objects in the image
%imfeatures --> find features of objects.

% Label all objects in finalMouthMap 
% numMouth = number of objects found in the mouthMap
% mouthStats = coordinates of the centroids for each object
[mouthMapLabel, numMouth] = bwlabel(finalMouthMap);
mouthStats = regionprops(mouthMapLabel, 'Centroid');

[eyeMapLabel, numEyes] = bwlabel(finalEyeMap);
eyeStats = regionprops(eyeMapLabel, 'Centroid');

%{
subplot(2,2,3);
mCentroids = cat(1, mouthStats.Centroid);
imshow(finalMouthMap)
hold on
plot(mCentroids(:,1),mCentroids(:,2), 'b*')
hold off

eCentroids = cat(1, eyeStats.Centroid);
subplot(2,2,4);
imshow(finalEyeMap)
hold on
plot(eCentroids(:,1),eCentroids(:,2), 'b*')
hold off
%}


end