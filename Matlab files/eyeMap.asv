%We need to send variables to the function from faceAlignment

function finalEyeMap = eyeMap(image, iycbcr, faceMask)

%----------------------------------------------------------------
%                   eyeMapC
%
% EyeMapC = 1/3 *(Cb^2 + (Cr inv))^2 + Cb/Cr)  
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

% Make eyeMapC binary
%level = graythresh(y);
%eyeMapCBinary = im2bw(uint8(eyeMapC), 0.5); %use imbinarize instead of im2bw

%----------------------------------------------------------------
%                   eyeMapL
%
% EyeMapL = Y(x,y) * gsigma((x,y) / Y(x,y) ** gsigma((x,y) + 1 
% * - dilation     ** - erotion
%----------------------------------------------------------------
% Change to graymap
imgGray = rgb2gray(image); 
imgGrayHist = histeq(imgGray);

% Create components for equation
SE = strel('disk', 15, 8); % radius = 15, n(number of segments) = 8
numerator =  imdilate(imgGrayHist, SE); % T?ljare
denumerator = 1 + imerode(imgGrayHist, SE); % N?mnare

% Create eyeMapL and normalize
eyeMapL = numerator ./ denumerator;
eyeMapL = normalizeMatrix(eyeMapL,0,255);

%----------------------------------------------------------------
%                    Combine eyeMapC and eyeMapL
%----------------------------------------------------------------
% Multiply C and L 
imgMult = (eyeMapC .* eyeMapL);

imgMult2 = (eyeMapC .*eyeMapL );
%----------------------------------------------------------------
%                    Refine eyeMap to get finalEyeMap
%----------------------------------------------------------------


% ---------
      
         grayImage = rgb2gray(image);

        % Step 3: Extract the individual red, green, and blue color channels.
        redChannel = image(:, :, 1);
        greenChannel = image(:, :, 2);
        blueChannel = image(:, :, 3);

        % Step 4: Mean 
        meanRed = mean2(redChannel);
        meanGreen = mean2(greenChannel);
        meanBlue = mean2(blueChannel);
        meanGray = mean2(grayImage);
        allMean = (meanRed + meanGreen + meanBlue + meanGray) / 4;

% ---------



% Normalize imgMult
imgMult = normalizeMatrix(imgMult,0,1);
imgMult2 = normalizeMatrix(imgMult2,0,1);


% Dilate imgMult
SDil = strel('disk', 6, 8); % radius = 10, n(number of segments) = 8
SDil2 = strel('disk', 6, 8); % radius = 10, n(number of segments) = 8

imgMultDil =  imdilate(imgMult, SDil);
%imgMultDil2 =  imdilate(imgMult2, SDil2);


% Make imgMultDil binary
imgMultDilBin = im2bw(imgMultDil, 0.5);    %use imbinarize instead of im2bw
%imgMultDilBin2 = im2bw(imgMultDil2, 0.5);    %use imbinarize instead of im2bw

mouthLevel = graythresh(image)
mouthLevel2 = (mouthLevel* 0.75)/2
imgMultDilBin2 = im2bw(imgMult2,mouthLevel2);

% Add facemask to imgMultDilBin
finalEyeMap = (imgMultDilBin .* faceMask);
finalEyeMap2 = (imgMultDilBin2 .* faceMask);

figure;
subplot(3,2,1);
imshow(image);
title('image'); 

subplot(3,2,2);
imshow(uint8(eyeMapC));
title('eyeMapC'); 

subplot(3,2,3);
imshow(uint8(eyeMapL));
title('eyeMapL'); 

subplot(3,2,4);
imshow(imgMult2);
title('imgMult2'); 

subplot(3,2,5);
imshow(finalEyeMap);
title('finalEyeMap'); 

subplot(3,2,6);
imshow(finalEyeMap2);
title('finalEyeMap2'); 

%----------------------------------------------------------------
%                    Plot images, use uint8 to plot images
%----------------------------------------------------------------
%{
subplot(2,4,4);
imshow(eyeMapCBinary);
title('eyeMapCBinary'); 

subplot(2,4,5);
imshow(imgMult);
title('imgMult');

subplot(2,4,6);
imshow(uint8(eyeMapL));
title('eyeMapL'); 

subplot(2,4,7);
imshow(faceMaskBin);
title('faceMaskBin'); 

subplot(2,4,8);
imshow(faceMaskEr);
title('faceMaskEr'); 
%}

end