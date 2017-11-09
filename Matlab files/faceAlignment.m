% PART 2: Face alignment
    % Find eyes using eye map 
        % Chrominance
        % Luminance 
        % Combine them to one map 
    % Mouthmap

function faceAlignment()

load ('db0Images');
image = db0Images{1};

% EyemapC = 1/3 *(Cb^2 + (Cr inv))^2 + Cb/Cr)
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

eyeMap = (cb2 + crinv2 + cbcr) ./3; 
imshow(eyeMap);


end