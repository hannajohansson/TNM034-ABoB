function faceMask = faceDetection(editedImage) 

    % Step 1: Create YCbCr image
    % Converts the truecolor image RGB to the equivalent 
    % image in the YCbCr color space
    ycbcrImage = rgb2ycbcr(editedImage);

    % Step 2: Convert crImage into a binary image using a threshold
    threshold = graythresh(crImage);
    imageMask = im2bw(crImage, threshold);
     figure, subplot(1, 3, 1), imshow(imageMask), title('Binary image (Mask)')

    % Step 3: Convert crImage into a binary image using a threshold
    threshold = graythresh(crImage);
    imageMask = im2bw(crImage, threshold);

    % Step 5: Morphological operations
    morphMask = bwmorph(imageMask, 'open');
     subplot(1, 4, 2), imshow(morphMask), title('Mask; open')

    se = strel('sphere', 9);
    morphMask = imdilate(morphMask,se);
    %maskMorph = bwmorph(maskMorph, 'close', 1000);
     subplot(1, 3, 2), imshow(morphMask), title('Morphological operations')

    % Step 6: Combine original image with the mask
    faceMask = originalImage .* morphMask;
     subplot(1, 3, 3), imshow(faceMask), title('Face Mask')

    %{ 
    % Step 6: Cb/Y, Cr/Y and Skin color samples in (Cb/Y) - (Cr/Y) subspace
    cbdivyImage = (cbImage./yImage)
    %cbdivyImage = cbdivyImage/max(abs(cbdivyImage(:)))
    subplot(2, 6, 7), imshow(cbdivyImage), title("Cb/Y Image")

    crdivyImage = (crImage./yImage);
    %crdivyImage = crdivyImage/max(abs(crdivyImage(:)))
    subplot(2, 6, 8), imshow(crdivyImage), title("Cr/Y Image")

    mapImage = cbdivyImage - crdivyImage;
    subplot(2, 6, 9), imshow(mapImage), title("Map Image")
    %}

    db1Faces{k} = faceMask;
    
    %save cell of images
    save 'db1Faces' db1Faces;  
    
end