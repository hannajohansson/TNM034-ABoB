% PART 2: Face alignment
    % Find eyes using eye map 
        % Chrominance
        % Luminance 
        % Combine them to one map 
    % Mouthmap

function faceAlignment()

load ('db0Images');
load ('db1Images');

image = db1Images{4};
% Eyedetection
% ---- EyeMapC = 1/3 *(Cb^2 + (Cr inv))^2 + Cb/Cr)  ----
iycbcr=rgb2ycbcr(image); %Convert to colorspace YCbCr
iycbcr = im2double(iycbcr); % Normalize
%imshow(iycbcr);

% Split into separate chanels
y= double(iycbcr(:,:,1)); 
cb=double(iycbcr(:,:,2));
cr=double(iycbcr(:,:,3));

% Create components for equation
cb2=cb.^2;
crinv2=(1-cr).^2;
cbcr=cb./cr;

eyeMapC = (cb2 + crinv2 + cbcr) /3; 


%  ---- EyeMapL = Y(x,y) * gsigma((x,y) / Y(x,y) ** gsigma((x,y) + 1 ----
% * - dilation ** - erotion
imgGray = rgb2gray(image); % Change to graymap
imgGrayHist = histeq(imgGray);

%{
subplot(2,2,1);
imshow(imgGray);
title('imgGray');

subplot(2,2,2);
imshow(imgGrayHist);
title('imgGrayHist');
%}

SE = strel('disk', 15, 8); % radius = 15, n(number of segments) = 8

% Create components for equation
numerator =  imdilate(imgGrayHist, SE); % T?ljare
denumerator = 1 + imerode(imgGrayHist, SE); % N?mnare

eyeMapL = double(numerator ./ denumerator) / 255;

%{
subplot(2,2,3);
imshow(eyeMapC);
title('eyeMapC');

subplot(2,2,4);
imshow(eyeMapL);
title('EyeMapL');
%}

% Combine C and L 

imgMult = (eyeMapC .* eyeMapL); 
%{
subplot(2,2,1);
imshow(eyeMapC);
title('eyeMapC');

subplot(2,2,2);
imshow(eyeMapL);
title('EyeMapL');

subplot(2,2,3);
imshow(imgMult);
title('imgMult');

%}

% ---- Mouth detection ----
% MouthMap = Cr^2 * (Cr^2 - eta*Cr/Cb)^2
% eta = 0,95 * 1/n * (sum of all elements in Cr^2 ) /(sum of all elements in Cr/Cb ) 

iycbcr=rgb2ycbcr(image); %Convert to colorspace YCbCr
%iycbcr = im2double(iycbcr) % Normalize
%imshow(iycbcr);

% Split into separate chanels
y= double(iycbcr(:,:,1)); 
cb=double(iycbcr(:,:,2));
cr=double(iycbcr(:,:,3));

% Create components for equation, has to be normalized to the range 0->255
cr2=cr.^2;
crcb=cr./cb;

etaNum = sum(cr(:).^2); 
etaDenum = sum(cr(:) ./ cb(:)); 

eta = 0.95 * (1/numel(cr)) * (etaNum / etaDenum);


mouthMapC = cr2 .* (cr2 - (eta.*crcb)).^2; 


subplot(1,2,1);
imshow(image);
title('image');

subplot(1,2,2);
imshow(mouthMapC);
title('mouthMapC'); 

end