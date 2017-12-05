% PART 2: Face alignment
    % Find eyes using eye map 
        % Chrominance
        % Luminance 
        % Combine them to one map 
    % Mouthmap

function [leftEyeCoords, rightEyeCoords, mouthCoords] = faceAlignment(editedImage, faceMask)

load ('db0Images');
load ('db1Images');
load ('db1Faces');

image = editedImage;

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
%                 find position of mouth and eyes
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
eCentroids = cat(1, eyeStats.Centroid);

[height, width, dim] = size(image);

%check if no mouth is found
if(numMouth == 0)    %isempty(mouthStats)
    mouthCoords(1,1) = width*0.5;
    mouthCoords(1,2) = height*0.75;
else 
    mouthCoords(1,1) = mCentroids(1,1);
    mouthCoords(1,2) = mCentroids(1,2);
    
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


%create index for all eyes found
if(numEyes < 3)
    index = zeros(2,2);
else 
    index = zeros(numEyes,2);
end

%check if no eyes are found
if(numEyes == 0)
    %calculate and save coords of first eye
    index(1,1) = width*0.45;
    index(1,2) = height * 0.6;
    
    %calculate and save coords of second eye
    index(2,1) = width*0.55;
    index(2,2) = height * 0.6;
    
%if one eye is found, mirror the coordinates of that eye
elseif(numEyes == 1)
    if  (eCentroids(1,1) > width*0.5) % right eye found
        index(2,1) = width*0.5 - (width*0.5 - eCentroids(1,1));
    else % left eye found
        index(2,1) = width*0.5 + (width*0.5 - eCentroids(1,1));
    end
    %use same y coordinate for both eyes
    index(2,2) = eCentroids(1,2);  
    
    %save the eyes in index
    index(1,:) = eCentroids(1,:);
    
%two or more eyes are found    
else
    a = 1;
    %loop over all eyes found
    for i = 1:numEyes
        %check if eyes are above the mouth in the image
        if (eCentroids(i,2) < mouthCoords(1,2)*0.7)
            index(a,1) = eCentroids(i,1);
            index(a,2) = eCentroids(i,2);
            a = a + 1;
        else
            %eyes below mouth are ignored
        end
    end 

    %If no eyes were found above the mouth
    if(a == 1) %no eye found  
        %calculate and save coords of first eye
        index(1,1) = width*0.45;
        index(1,2) = height * 0.6;

        %calculate and save coords of second eye
        index(2,1) = width*0.55;
        index(2,2) = height * 0.6;
    elseif(a == 2)  %one eye found
        if  (index(1,1) > width*0.5) % right eye found
            index(2,1) = width*0.5 - (width*0.5 - index(1,1));
        else % left eye found
            index(2,1) = width*0.5 + (width*0.5 - index(1,1));
        end
        %use same y coordinate for both eyes
        index(2,2) = index(1,2);  
    end
end


%----------------------------------------------------------------
%                 plot images, use uint8 to plot images
%----------------------------------------------------------------
%{
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
%}
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
%                 plot triangle for eyes and mouth
%----------------------------------------------------------------
%{
subplot(2,2,2);
imshow(image)
hold on
%draw lines between eyes and mouth
% 1) Line between left eye and right eye
line([leftEyeCoords(1),rightEyeCoords(1)],[leftEyeCoords(2),rightEyeCoords(2)],'LineWidth',2, 'color','r')
% 2) Line between left eye and mouth
line([leftEyeCoords(1),mouthCoords(1)],[leftEyeCoords(2),mouthCoords(2)],'LineWidth',2, 'color','r')
% 3) Line between right eye and mouth
line([rightEyeCoords(1),mouthCoords(1)],[rightEyeCoords(2), mouthCoords(2)],'LineWidth',2, 'color','r')
hold off
%}

end