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

currentFace = 12;
image = db1Images{currentFace};
faceMask = db1Faces{currentFace};
%image = db0Images{2};

%Convert to colorspace YCbCr
iycbcr = rgb2ycbcr(image); 

%----------------------------------------------------------------
%                    faceMask
%----------------------------------------------------------------
% Make faceMask binary
faceMaskBin = im2bw(faceMask, 0.01);    %use imbinarize instead of im2bw
SEr = strel('disk', 30, 8); % radius = 10, n(number of segments) = 8
SDil = strel('disk', 6, 8); % radius = 10, n(number of segments) = 8
faceMask = imerode(imdilate(faceMaskBin, SDil), SEr);

%----------------------------------------------------------------
%                   eyes and mouth detection
%----------------------------------------------------------------

finalEyeMap = eyeMap(image, iycbcr, faceMask);
finalMouthMap = mouthMap(image, iycbcr, faceMask);


%----------------------------------------------------------------
%                    Plot images, use uint8 to plot images
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
eyeMapL = normalize_matrix(eyeMapL,0,255);


%----------------------------------------------------------------
%                    Combine eyeMapC and eyeMapL
%----------------------------------------------------------------
% Multiply C and L 
imgMult = (eyeMapC .* eyeMapL);

%----------------------------------------------------------------
%                    Refine eyeMap to get finalEyeMap
%----------------------------------------------------------------

% Normalize imgMult
imgMult = normalize_matrix(imgMult,0,1);

% Dilate imgMult
imgMultDil =  imdilate(imgMult, SDil);

% Make imgMultDil binary
imgMultDilBin = im2bw(imgMultDil, 0.5);    %use imbinarize instead of im2bw


%{
figure; 
subplot(2,2,1);
imshow(eyeMapCBinary);
title('eyeMapCBinary'); 


% -------------- PLOT ---------------
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
%}

%               --------------- Mouth detection ---------------
% MouthMap = Cr^2 * (Cr^2 - eta*Cr/Cb)^2
% eta = 0,95 * 1/n * (sum of all elements in Cr^2 ) /(sum of all elements in Cr/Cb ) 

% Split into separate chanels
y =histeq(iycbcr(:,:,1)); 
cb=histeq(iycbcr(:,:,2));
cr=(iycbcr(:,:,3));


subplot(2,2,4);
imshow(finalMouthMap);
title('finalMouthMap');


%----------------------------------------------------------------
%                    Find position of objects
%----------------------------------------------------------------

%bwlabel --> label all objects in the image
%imfeatures --> find features of objects. typ mitten av ett object/central
%mass

end