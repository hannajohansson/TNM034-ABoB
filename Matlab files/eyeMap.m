function finalEyeMap = eyeMap(image, iycbcr, faceMask)
%----------------------------------------------------------------
%                   eyeMapC
%
%    EyeMapC = 1/3 *(Cb^2 + (Cr inv))^2 + Cb/Cr)  
%----------------------------------------------------------------
% Split into separate chanels, should be normalized [0,255]
y = iycbcr(:,:,1);
cb = iycbcr(:,:,2);
cr = iycbcr(:,:,3);

% Create components for equation
cb2 = cb.^2;
crinv2 = (255-cr).^2;
cbcr = cb./cr;

% Normalize to [0,255]
cb2 = normalizeMatrix(cb2,0,255);
crinv2 = normalizeMatrix(crinv2,0,255);
cbcr = normalizeMatrix(cbcr,0,255);

% Create eyeMapC and normalize
eyeMapC = (cb2 + crinv2 + cbcr) ./ 3;
eyeMapC = normalizeMatrix(eyeMapC,0,255);

%----------------------------------------------------------------
%                   eyeMapL
%
% EyeMapL = Y(x,y) * gsigma((x,y) / Y(x,y) ** gsigma((x,y) + 1 
% * - dilation     ** - erotion
%----------------------------------------------------------------
% Change to graymap
imgGray = histeq(rgb2gray(image)); 

% Create components for equation
dilL = strel('disk', 3, 8); % radius = 15, n(number of segments) = 8
erL = strel('disk', 10, 8); % radius = 15, n(number of segments) = 8
numerator =  imdilate(imgGray, dilL); % T?ljare
denumerator = 1 + imerode(imgGray, erL); % N?mnare

% Create eyeMapL and normalize
eyeMapL = numerator ./ denumerator;
eyeMapL = normalizeMatrix(eyeMapL,0,255);

%----------------------------------------------------------------
%                    Combine eyeMapC and eyeMapL
%----------------------------------------------------------------
imgMult = (eyeMapC .* eyeMapL);

%----------------------------------------------------------------
%                    Refine eyeMap to get finalEyeMap
%----------------------------------------------------------------
% Normalize imgMult
imgMult = normalizeMatrix(imgMult,0,1);

% Dilate and erode imgMult
dilMult = strel('disk', 5, 8);
erMult = strel('disk', 2, 8);
imgMult =  imerode(imdilate(imgMult, dilMult), erMult);

% Make imgMultDil binary
level = (1- (graythresh(imgMult) + graythresh(y))/2);
imgMultBin = im2bw(imgMult, (level-0.15)); 

% Add facemask to imgMultDilBin
finalEyeMap = (imgMultBin .* faceMask);

%----------------------------------------------------------------
%                    Remmove unnessesary pixles
%----------------------------------------------------------------
[height, width, dim] = size(finalEyeMap);
for r = 1:height %row
    for c = 1:width %column
        if(r < height*0.3) %top
            finalEyeMap(r,c) = 0;
        elseif(r > height*0.6) %bottom
            finalEyeMap(r,c) = 0;
        end
   
        if(c < width *0.1) %left
            finalEyeMap(r,c) = 0;
        elseif(c > width *0.9) %right
            finalEyeMap(r,c) = 0;
        end
    end
end

%----------------------------------------------------------------
%      Filter objects in finalEyeMap depending on size of area
%      Keep 2 largest areas in the eyeMap
%----------------------------------------------------------------
finalEyeMap = bwareafilt(logical(finalEyeMap),2);

%----------------------------------------------------------------
%      Plot images, use uint8 to plot double images 
%----------------------------------------------------------------
%{
figure;
subplot(4,4,1);
imshow(image);
title('image'); 

subplot(3,2,2);
imshow(uint8(eyeMapC));
title('eyeMapC'); 

subplot(3,2,3);
imshow(uint8(eyeMapL));
title('eyeMapL'); 

subplot(3,2,4);
imshow(imgMult);
title('imgMult'); 

subplot(3,2,5);
imshow(finalEyeMap);
title('finalEyeMap'); 
%}
end