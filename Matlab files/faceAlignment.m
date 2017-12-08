function [leftEyeCoords, rightEyeCoords] = faceAlignment(editedImage, faceMask)
load ('db1Images');

image = editedImage;

%----------------------------------------------------------------
%                 Refine and apply the faceMask to our image
%----------------------------------------------------------------
% Make faceMask binary
faceMaskBin = im2bw(faceMask, 0.01);    

% Dilate and erode using strel(radius, number of segments) 
ErFace = strel('disk', 20, 8); 
ErFace2 = strel('disk', 20, 8);
DilFace = strel('disk', 10, 8);
faceMask = imerode(imerode(imdilate(faceMaskBin, DilFace), ErFace), ErFace2);

% Use the faceMask to make non-face-points gray
[height, width, dim] = size(image);
for r = 1:height
    for c = 1:width
        if(faceMask(r,c) == 0) 
            image(r,c, :) = 0.5;
        end
    end
end

%Convert to colorspace YCbCr
iycbcr = rgb2ycbcr(image); 

%----------------------------------------------------------------
%                 eyes and mouth detection
%----------------------------------------------------------------
finalEyeMap = eyeMap(image, iycbcr, faceMask);
finalMouthMap = mouthMap(image, iycbcr, faceMask);

%----------------------------------------------------------------
%                 find and label positions of mouth and eyes
%----------------------------------------------------------------
%bwlabel --> label all objects in the image
%imfeatures --> find features of objects.

%mouth
%numMouth = number of objects found in the mouthMap
%mouthStats = coordinates of the centroids for each object
[mouthMapLabel, numMouth] = bwlabel(finalMouthMap);
mouthStats = regionprops(mouthMapLabel, 'Centroid');
mCentroids = cat(1, mouthStats.Centroid);

%eye
[eyeMapLabel, numEyes] = bwlabel(finalEyeMap);
eyeStats = regionprops(eyeMapLabel, 'Centroid');
eCentroids = cat(1, eyeStats.Centroid);

%----------------------------------------------------------------
%             find the best mouth position
%----------------------------------------------------------------
[height, width, dim] = size(image);

%correct mouthposition is stored in mouthCoords
if(numMouth == 0) 
    %no mouth found -> add a defaut mouth
    mouthCoords(1,1) = width*0.5;
    mouthCoords(1,2) = height*0.75;
elseif(numMouth == 1) 
    %one mouth found -> save positions
    mouthCoords(1,1) = mCentroids(1,1);
    mouthCoords(1,2) = mCentroids(1,2);
else 
    %two mouths found (bwareafilt in mouthMap.m gives max two mouths)
    %-> find the best 
    
    %check distance to center, pick the most centered mouth
    if (abs(mCentroids(1,2) - mCentroids(2,2)) < (height *0.015))  
        %mouths to close 
        firstDist = width*0.5 - mCentroids(1,1);
        secondDist = width*0.5 - mCentroids(2,1);
     
        if firstDist > secondDist 
           mouthCoords(1,1) = mCentroids(2,1);
           mouthCoords(1,2) = mCentroids(2,2);
        else
           mouthCoords(1,1) = mCentroids(1,1);
           mouthCoords(1,2) = mCentroids(1,2);
        end 
    else
        if mCentroids(1,2) > mCentroids(2,2) 
            mouthCoords(1,:) = mCentroids(1,:);
        else 
            mouthCoords(1,:) = mCentroids(2,:);
        end        
    end
end

%----------------------------------------------------------------
%             find the best eye positions
%----------------------------------------------------------------
%create index for all eyes found. This is where we store the best eyes
if(numEyes < 3)
    index = zeros(2,2);
else 
    index = zeros(numEyes,2);
end

%check how many eyes found
%no eyes found -> create two defalut eyes and store them in index
if(numEyes == 0)
    %if no mouth is found
    if(numMouth == 0) 
        %left eye
        index(1,1) = width*0.45;
        index(1,2) = height * 0.6;

        %right eye
        index(2,1) = width*0.55;
        index(2,2) = height * 0.6;
        
    %if mouth is found
    else
        %left eye
        index(1,1) = mouthCoords(1,1)*0.8;
        index(1,2) = mouthCoords(1,2)*0.4;

        %right eye
        index(2,1) = mouthCoords(1,1)*1.2;
        index(2,2) = mouthCoords(1,2)*0.4;
    end    
    
elseif(numEyes == 1)
    %one eye is found -> mirror the coordinates of that eye
    
    % right eye found
    if  (eCentroids(1,1) > mouthCoords(1,1)) 
        index(2,1) = mouthCoords(1,1) - (mouthCoords(1,1) - eCentroids(1,1));
    % left eye found
    else 
        index(2,1) = mouthCoords(1,1) + (mouthCoords(1,1) - eCentroids(1,1));
    end
    
    %use same y coordinate for both eyes
    index(2,2) = eCentroids(1,2);  
    
    %save the first eyes in index
    index(1,:) = eCentroids(1,:);
    
  
else
    %two eyes are found ( bwareafilt in eyeMap.m gives max two eyes)
    % -> check if these are okej
    a = 1;

    %loop over all eyes found
    for i = 1:numEyes
        %check if eyes are above the mouth in the image (Y position)
        if (eCentroids(i,2) < mouthCoords(1,2)*0.8)
            index(a,1) = eCentroids(i,1);
            index(a,2) = eCentroids(i,2);
            a = a + 1;
        end
    end 
    
    %Check how many okey eyes
    if(a == 1) %all eyes where below mouth, not okej
        %create two default eyes and store them in index
       %if no mouth is found
        if(numMouth == 0) 
            %left eye
            index(1,1) = width*0.45;
            index(1,2) = height * 0.6;

            %right eye
            index(2,1) = width*0.55;
            index(2,2) = height * 0.6;

        %if mouth is found
        else
            %left eye
            index(1,1) = mouthCoords(1,1)*0.8;
            index(1,2) = mouthCoords(1,2)*0.4;

            %right eye
            index(2,1) = mouthCoords(1,1)*1.2;
            index(2,2) = mouthCoords(1,2)*0.4;
        end 
        
    elseif(a == 2)  
        %one eye is found -> mirror the coordinates of that eye
        % right eye found
        if  (eCentroids(1,1) > mouthCoords(1,1)) 
            index(2,1) = mouthCoords(1,1) - (mouthCoords(1,1) - eCentroids(1,1));
        % left eye found
        else 
            index(2,1) = mouthCoords(1,1) + (mouthCoords(1,1) - eCentroids(1,1));
        end
        
        %use same y coordinate for both eyes
        index(2,2) = index(1,2);  
    end
end
%----------------------------------------------------------------
%                 save coordinates of eyes
%----------------------------------------------------------------
%check position to get right and left eye
if index(1,1) < index(2,1)
    leftEyeCoords(1,:) = index(1,:);
    rightEyeCoords(1,:) = index(2,:);
else
    leftEyeCoords(1,:) = index(2,:);
    rightEyeCoords(1,:) = index(1,:);
end

%----------------------------------------------------------------
%                 save coordinates of eyes
%----------------------------------------------------------------
%check position to get right and left eye
if index(1,1) < index(2,1)
    leftEyeCoords(1,:) = index(1,:);
    rightEyeCoords(1,:) = index(2,:);
else
    leftEyeCoords(1,:) = index(2,:);
    rightEyeCoords(1,:) = index(1,:);
end

%----------------------------------------------------------------
%                 plot images, use uint8 to plot images
%----------------------------------------------------------------


figure;
subplot(2,2,1);
imshow(faceMask);
title('faceMask'); 

subplot(2,2,3);
imshow(finalMouthMap)
hold on
plot(mouthCoords(1),mouthCoords(2), 'b*')
hold off

subplot(2,2,4);
imshow(finalEyeMap)
hold on
plot(index(:,1),index(:,2), 'b*')
hold off


%----------------------------------------------------------------
%                 plot triangle for eyes and mouth
%----------------------------------------------------------------

%{
figure%, subplot(2,2,2);
imshow(image)
hold on

% 1) Line between left eye and right eye
line([leftEyeCoords(1),rightEyeCoords(1)],[leftEyeCoords(2),rightEyeCoords(2)],'LineWidth',2, 'color','r')
% 2) Line between left eye and mouth
line([leftEyeCoords(1),mouthCoords(1)],[leftEyeCoords(2),mouthCoords(2)],'LineWidth',2, 'color','r')
% 3) Line between right eye and mouth
line([rightEyeCoords(1),mouthCoords(1)],[rightEyeCoords(2), mouthCoords(2)],'LineWidth',2, 'color','r')
hold off
%}


end