function faceMask = faceDetection(editedImage) 

    % Step 1: Create YCbCr image
    % Converts the truecolor image RGB to the equivalent 
    % image in the YCbCr color space
    ycbcrImage = rgb2ycbcr(editedImage);

    % Step 2: Create Luminance Image, Blue Chroma Image and Red Croma Image
    yImage = ycbcrImage(:,:,1);
    cbImage = ycbcrImage(:,:,2);
    crImage = ycbcrImage(:,:,3);

    % Step 3: Convert crImage into a binary image using a threshold
    threshold = graythresh(crImage);
    imageMask = im2bw(crImage, threshold);

    % Calculate the euler number 
    %(number of objects in the region minus the number of holes in those objects)
    bweuler(imageMask);

    % Step 4: Morphological operations
    morphMask = bwmorph(imageMask, 'open');
    se = strel('sphere', 9);
    morphMask = imdilate(morphMask,se);

    % Step 5: Combine original image with the mask
    faceMask = editedImage .* morphMask;
    
end