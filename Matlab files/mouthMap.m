function finalMouthMap = mouthMap(image, iycbcr, faceMask)
%   When we work with doubles, the normalization = [0,1] <- now! 
%   When we work with uint8, the normalization = [0,255]

%----------------------------------------------------------------
%                   MouthMap
%
% MouthMap = Cr^2 * (Cr^2 - eta*Cr/Cb)^2
% eta = 0,95 * 1/n * (sum of all elements in Cr^2 ) /(sum of all elements in Cr/Cb ) 
%----------------------------------------------------------------
% Split into separate chanels
y = histeq(iycbcr(:,:,1)); 
cb = histeq(iycbcr(:,:,2));
cr = (iycbcr(:,:,3));

% Create components for equation, (has to be normalized to the range 0->1)
cr2 = cr.^2 ;
cr2 = normalizeMatrix(cr2, 0, 1); 
crcb = cr./cb;
crcb = normalizeMatrix(crcb, 0, 1);

% Calculate eta  
etaNum = mean2(cr.^2);
etaDenum = mean2(cr(:) ./ cb(:)); 
eta = 0.95  * (etaNum / etaDenum);

% Calculate the mouthMap 
mouthMap = cr2 .* (cr2 - (eta.*crcb)).^2;
mouthMap = normalizeMatrix(mouthMap, 0, 1);

%----------------------------------------------------------------
%                    Refine mouthMap to get finalMouthMap
%----------------------------------------------------------------
% Dilation and erosion
DilMouth = strel('disk', 20, 8); % radius = 15, n(number of segments) = 8
ErMouth = strel('disk', 16, 8); % radius = 15, n(number of segments) = 8
mouthMap = imdilate(im2uint8(mouthMap), DilMouth);
mouthMap = imerode(im2uint8(mouthMap), ErMouth);

% Make binary using treshhold
mouthLevel = graythresh(image); 
mouthMapBw = im2bw(mouthMap,(mouthLevel +0.2) );

% Add facemask to mouthMapBw
finalMouthMap = (mouthMapBw .* faceMask);

%----------------------------------------------------------------
%                    Remmove unnessesary pixles
%----------------------------------------------------------------
[height, width, dim] = size(finalMouthMap);
for r = 1:height %row
    for c = 1:width %column
        if(r < height*0.45) %top
            finalMouthMap(r,c) = 0;
        elseif(r > height*0.9) %bottom
            finalMouthMap(r,c) = 0;
        else
        end
        
        if(c < width *0.1) %left
            finalMouthMap(r,c) = 0;
        elseif(c > width *0.9) %right
            finalMouthMap(r,c) = 0;
        else
        end
    end
end

%----------------------------------------------------------------
%      Filter objects in finalMouthMap depending on size of area
%      Keep 2 largest areas in the eyeMap
%----------------------------------------------------------------
finalMouthMap = bwareafilt(logical(finalMouthMap),2);

%----------------------------------------------------------------
%                    Plot images
%----------------------------------------------------------------
%{
figure;
subplot(2,2,1);
imshow(image);
title('image'); 

subplot(2,2,2);
imshow(finalMouthMap);
title('finalMouthMap'); 
%}

end