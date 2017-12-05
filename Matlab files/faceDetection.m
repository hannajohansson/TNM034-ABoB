function [faceMask] = faceDetection(editedImage) 

    % Step 1: Create YCbCr image
    % Converts the truecolor image RGB to the equivalent image in the YCbCr color space
    ycbcrImage = rgb2ycbcr(editedImage);
    
    yImage = ycbcrImage(:,:,1);
    cbImage = ycbcrImage(:,:,2);
    crImage = ycbcrImage(:,:,3);

    % Step 2: Convert crImage into a binary image using a threshold
    threshold = graythresh(crImage);
    imageMask = im2bw(crImage, threshold);

    % Step 3: Convert crImage into a binary image using a threshold
    threshold = graythresh(crImage);
    imageMask = im2bw(crImage, threshold);

    % Step 5: Morphological operations
    morphMask = bwmorph(imageMask, 'open');

    se = strel('sphere', 9);
    morphMask = imdilate(morphMask,se);

    % Step 6: Combine original image with the mask
    faceMask = editedImage .* morphMask;
    
end