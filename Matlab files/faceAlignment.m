% PART 2: Face alignment
    % Find eyes using eye map 
        % Chrominance
        % Luminance 
        % Combine them to one map 
    % Mouthmap

function faceAlignment()

load ('db0Images');
load ('db1Images');

image = db1Images{2};

% ---- EyeMapC = 1/3 *(Cb^2 + (Cr inv))^2 + Cb/Cr)  ----
iycbcr=rgb2ycbcr(image); %Convert to colorspace YCbCr
iycbcr = im2double(iycbcr); % Normalize
imshow(iycbcr);

% Split into separate chanels
y=iycbcr(:,:,1); 
cb=iycbcr(:,:,2);
cr=iycbcr(:,:,3);

% Create components for equation
cb2=cb.^2;
crinv2=(1-cr).^2;
cbcr=cb./cr;

eyeMapC = (cb2 + crinv2 + cbcr) ./3; 


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

eyeMapL = numerator ./denumerator; 

%{
subplot(2,2,3);
imshow(eyeMapC);
title('eyeMapC');

subplot(2,2,4);
imshow(eyeMapL);
title('EyeMapL');
%}

end