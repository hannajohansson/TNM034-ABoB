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
SEr2 = strel('disk', 5, 8); % radius = 10, n(number of segments) = 8
SDil = strel('disk', 6, 8); % radius = 10, n(number of segments) = 8
faceMask = imerode(imerode(imdilate(faceMaskBin, SDil), SEr), SEr2);

%----------------------------------------------------------------
%                 eyes and mouth detection
%----------------------------------------------------------------
finalEyeMap = eyeMap(image, iycbcr, faceMask);
finalMouthMap = mouthMap(image, iycbcr, faceMask);

%----------------------------------------------------------------
%                 plot images, use uint8 to plot images
%----------------------------------------------------------------

figure;
subplot(2,2,1);
imshow(faceMask);
title('faceMask'); 

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
mCentroids = cat(1, mouthStats.Centroid);
    
[eyeMapLabel, numEyes] = bwlabel(finalEyeMap);
eyeStats = regionprops(eyeMapLabel, 'Centroid');
numEyes;

[height, width, dim] = size(image);

%check if no mouth is found
if(numMouth == 0)    %isempty(mouthStats)
    mCentroids(1,1) = width*0.5;
    mCentroids(1,2) = height*0.75;
elseif numMouth == 1

else 
    %{
    firstDist = width*0.5 - mCentroids(1,1);
    secondDist = width*0.5 - mCentroids(2,1);
    % We use the first centroid in mCentroids. If the second "mouth" is
    % closer to the middle, we want to use that instead
    if firstDist > secondDist 
        mCentroids(1,1) = mCentroids(2,1);
        mCentroids(1,2) = mCentroids(2,2);
    end
    %}
end

subplot(2,2,3);
imshow(finalMouthMap)
hold on
plot(mCentroids(:,1),mCentroids(:,2), 'b*')
hold off

if(numEyes < 3)
    index = zeros(1,2);
else 
    index = zeros(1,numEyes);
end

eCentroids = cat(1, eyeStats.Centroid);


%check if no eyes are found
if(numEyes == 0)   
    eCentroids(1,1) = width*0.45;
    eCentroids(1,2) = height * 0.6;
    index(1,1) = 1;
    index(1,2) = 2;
    
    eCentroids(2,1) = width*0.55;
    eCentroids(2,2) = height * 0.6;
    index(1,1) = 1;
    index(1,2) = 2;
elseif(numEyes == 1)
    if  eCentroids(1,1) > width*0.5 % right eye found
        eCentroids(2,1) = width*0.5 - (width*0.5 - eCentroids(1,1));
    else % left eye found
        eCentroids(2,1) = width*0.5 + (width*0.5 - eCentroids(1,1));
    end
    eCentroids(2,2) = eCentroids(1,2);
    index(1,1) = 1;
    index(1,2) = 2;
    
else
    a = 1;
    for i = 1:numEyes
        x = eCentroids(i,1);
        y = eCentroids(i,2);
        mouthX = mCentroids(1,1);
        mouthY = mCentroids(1,2);
        
        %Check if the coordinates of the eyes are good
        if (y < mouthY*0.7 && y > 0.2*height)
            index(1,a) = i;
            a = a + 1;
        else
   
        end
    end 

    %If all "eyes" were below the mouth
    if(a == 1)   
        eCentroids(1,1) = width/2;
        eCentroids(1,2) = height/2;
        index(1,1) = 1;
        index(1,2) = 2;
    elseif(a == 2)
        eCentroids(2,1) = width/2;
        eCentroids(2,2) = height * 0.75;
        index(1,1) = 1;
        index(1,2) = 2;
    end
end

index ;


subplot(2,2,4);
imshow(finalEyeMap)
hold on
plot(eCentroids(:,1),eCentroids(:,2), 'b*')
hold off

subplot(2,2,2);
imshow(image)
hold on
%draw lines between eyes and mouth
line([eCentroids(index(1,1),1),eCentroids(index(1,2),1)],[eCentroids(index(1,1),2),eCentroids(index(1,2),2)],'LineWidth',2, 'color','r')
line([eCentroids(index(1,1),1),mCentroids(1,1)],[eCentroids(index(1,1),2),mCentroids(1,2)],'LineWidth',2, 'color','r')
line([eCentroids(index(1,2),1),mCentroids(1,1)],[eCentroids(index(1,2),2),mCentroids(1,2)],'LineWidth',2, 'color','r')
hold off


end