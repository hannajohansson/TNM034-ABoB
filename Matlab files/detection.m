function detection() 
%Find face mask

% Step 1: Load image
load ('db0Images');
original_image = db0Images{1};
subplot(2, 6, 1), imshow(original_image), title("Original Image")

% Step 2: Create YCbCr image
% Converts the truecolor image RGB to the equivalent 
% image in the YCbCr color space
yCbCr_image = rgb2ycbcr(original_image);
subplot(2, 6, 2), imshow(yCbCr_image), title("YCbCr Image")

% Step 3: Create HSV image
% Converts the RGB image to the equivalent HSV image
hsv_image = rgb2hsv(original_image);
subplot(2, 6, 3), imshow(hsv_image), title("HSV Image")

% Step X: Create HSV-saturation image
% 1: hue, 2: saturation, 3: value
%new_image = hsv_image(:,:,2);
%subplot(1, 6, 4), imshow(new_image), title("Saturation Channel")

% Step 4: Create Luminance Image, Blue Chroma Image and Red Croma Image
Y_image = yCbCr_image(:,:,1);
subplot(2, 6, 4), imshow(Y_image), title("Luminance Image")

Cb_image = yCbCr_image(:,:,2);
subplot(2, 6, 5), imshow(Cb_image), title("Blue Chroma Image")

Cr_image = yCbCr_image(:,:,3);
subplot(2, 6, 6), imshow(Cr_image), title("Red Chroma Image")

% Step 6: Cb/Y, Cr/Y and Skin color samples in (Cb/Y) - (Cr/Y) subspace
CbdivY_image = double(Cb_image./Y_image)
%CbdivY_image = CbdivY_image/max(abs(CbdivY_image(:)))
subplot(2, 6, 7), imshow(CbdivY_image), title("Cb/Y Image")

CrdivY_image = double(Cr_image./Y_image);
%CrdivY_image = CrdivY_image/max(abs(CrdivY_image(:)))
subplot(2, 6, 8), imshow(CrdivY_image), title("Cr/Y Image")

map_image = CbdivY_image - CrdivY_image;
subplot(2, 6, 9), imshow(map_image), title("Map Image")
end