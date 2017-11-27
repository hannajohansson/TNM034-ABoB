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
faceMaskEr = imerode(imdilate(faceMaskBin, SDil), SEr);


%                ----- Eyedetection -----
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
cb2 = normalize_matrix(cb2,0,255);
crinv2 = normalize_matrix(crinv2,0,255);
cbcr = normalize_matrix(cbcr,0,255);

% Create eyeMapC and normalize
eyeMapC = (cb2 + crinv2 + cbcr) ./ 3;
eyeMapC = normalize_matrix(eyeMapC,0,255);

% Make eyeMapC binary
%level = graythresh(y);
eyeMapCBinary = im2bw(uint8(eyeMapC), 0.5); %use imbinarize instead of im2bw


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
subplot(2,4,1);
imshow(image);
title('image'); 

subplot(2,4,2);
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


subplot(2,4,3);
imshow(uint8(eyeMapC));
title('eyeMapC'); 

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



%--------------- Mouth detection ---------------
%mouthMap();


%--------------- Find position of objects ---------------

%bwlabel --> label all objects in the image
%imfeatures --> find features of objects. typ mitten av ett object/central
%mass

end