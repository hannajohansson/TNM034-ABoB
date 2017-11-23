% PART 2: Face alignment
    % Find eyes using eye map 
        % Chrominance
        % Luminance 
        % Combine them to one map 
    % Mouthmap

function faceAlignment()

load ('db0Images');
load ('db1Images');
load ('db1Faces');

currentFace = 5;
image = db1Images{currentFace};
faceMask = db1Faces{currentFace};
%image = db0Images{2};

imageUint8 = im2uint8(image);
iycbcrUint8=rgb2ycbcr(im2double(imageUint8)); %Convert to colorspace YCbCr

iycbcr = rgb2ycbcr(image);
%iycbcrIm = double2im(iycbcr);
% Koden funkar inte med edit_image 

%                ----- Eyedetection -----
% EyeMapC = 1/3 *(Cb^2 + (Cr inv))^2 + Cb/Cr)  

% Split into separate chanels
y= iycbcrUint8(:,:,1);
cb=iycbcrUint8(:,:,2);
cr=iycbcrUint8(:,:,3);

% Create components for equation
cb2=cb.^2;
crinv2=(1-cr).^2;
cbcr=cb./cr;

eyeMapC = (cb2 + crinv2 + cbcr) /3;

%Make eyeMapC binary
level = graythresh(y);
eyeMapCBinary = im2bw(eyeMapC, level);    %use imbinarize instead of im2bw

% Calculate eyeMap 
% EyeMapL = Y(x,y) * gsigma((x,y) / Y(x,y) ** gsigma((x,y) + 1 
% * - dilation     ** - erotion
    %imgGray = rgb2gray(im2double(image)); % Change to graymap
    imgGray = rgb2gray((imageUint8)); % Change to graymap
imgGrayHist = histeq(imgGray);

SE = strel('disk', 15, 8); % radius = 15, n(number of segments) = 8

% Create components for equation
numerator =  imdilate(imgGrayHist, SE); % T?ljare
denumerator = 1 + imerode(imgGrayHist, SE); % N?mnare

eyeMapL = double(numerator ./ denumerator)/255;

%{
% Multiply C and L 
imgMult = (eyeMapCBinary .* eyeMapL);
SDil = strel('disk', 10, 8); % radius = 10, n(number of segments) = 8
imgMultDil =  imdilate(imgMult, SDil);
%}

% Fuse C and L
imgFuse = rgb2gray(imfuse(eyeMapL,eyeMapCBinary));
SDil = strel('disk', 10, 8); % radius = 10, n(number of segments) = 8
imgFuseDil =  imdilate(imgFuse, SDil);

% Make imgFuseDil binary
imgFuseDilBin = im2bw(imgFuseDil, 0.7);    %use imbinarize instead of im2bw

% Make faceMask binary
faceMaskBin = im2bw(faceMask, 0.01);    %use imbinarize instead of im2bw
SEr = strel('disk', 30, 8); % radius = 10, n(number of segments) = 8
faceMaskEr = imerode(imdilate(faceMaskBin, SDil), SEr);

% Add facemask to imgFuseDilBin
finalEyeMap = (imgFuseDilBin .* faceMaskEr);

%{
figure; 
subplot(2,2,1);
imshow(eyeMapCBinary);
title('eyeMapCBinary'); 

subplot(2,2,2);
imshow(faceMaskEr);
title('faceMaskEr'); 

subplot(2,2,3);
imshow(faceMaskBin);
title('faceMaskBin'); 

subplot(2,2,4);
imshow(finalEyeMap);
title('finalEyeMap'); 
%}

%               --------------- Mouth detection ---------------
% MouthMap = Cr^2 * (Cr^2 - eta*Cr/Cb)^2
% eta = 0,95 * 1/n * (sum of all elements in Cr^2 ) /(sum of all elements in Cr/Cb ) 

% Split into separate chanels
y =histeq(iycbcr(:,:,1)); 
cb=histeq(iycbcr(:,:,2));
cr=(iycbcr(:,:,3));

% Create components for equation, has to be normalized to the range 0->1
%   When we work with doubles, the normalization = [0,1] <- now! 
%   When we work with uint8, the normalization = [0,255]
cr2=cr.^2 ;
cr2Norm = ((cr2 -min(cr2(:)))./ ( max(cr2(:) - min(cr2(:))))); 
crcb=cr./cb;
crcbNorm = ((crcb -min(cbcr(:))) ./ ( max(crcb(:) - min(cbcr(:)))));

% Calculate eta  
etaNum = mean2(cr.^2);
etaDenum = mean2(cr(:) ./ cb(:)); 
eta = 0.95  * (etaNum / etaDenum);

% Calculate the mouthMap 
mouthMapC = cr2Norm .* (cr2Norm - (eta.*crcbNorm)).^2;

% dilation and erosion
SED = strel('disk', 20, 8); % radius = 15, n(number of segments) = 8
%SED = strel('rectangle', [3,10]);
SEE = strel('disk', 16, 8); % radius = 15, n(number of segments) = 8
%SEE = strel('rectangle', [3,10]); % radius = 15, n(number of segments) = 8


mouthMapCDil = imdilate(im2uint8(mouthMapC), SED);
%mouthMapCEr = imerode(im2uint8(mouthMapC), SE2);

mouthMapDE = imerode(im2uint8(mouthMapCDil), SEE);

% mouthMapCDil = imdilate(mouthMapC);

%{
figure;
subplot(2,2,1);
imshow(mouthMapCDil);
title('mouthMapCDil'); 

subplot(2,2,2);
imshow(mouthMapDE);
title('mouthMapDE'); 

subplot(2,2,3);
imshow(mouthMapC);
title('mouthMapC'); 

subplot(2,2,4);
imshow(image);
title('image'); 
%}


end