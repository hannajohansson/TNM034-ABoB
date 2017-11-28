function faceMask = faceDetection_OLD(image, editedImage) 

    % Step 1: Load images
    load ('db1Images');
    
    % db1Faces
    numfiles1 = 16;
    db1Faces = cell(1, numfiles1);
    
    for k = 1:16
        originalImage = im2double(db1Images{k});
        % subplot(1, 5, 1), imshow(originalImage), title('Original Image')

        % Step 2: Create YCbCr image
        % Converts the truecolor image RGB to the equivalent 
        % image in the YCbCr color space
        ycbcrImage = rgb2ycbcr(originalImage);
        % subplot(1, 5, 2), imshow(ycbcrImage), title('YCbCr Image')

        % Step 3: Create Luminance Image, Blue Chroma Image and Red Croma Image
        yImage = ycbcrImage(:,:,1);
        cbImage = ycbcrImage(:,:,2);
        crImage = ycbcrImage(:,:,3);
        % subplot(1, 5, 3), imshow(yImage), title('Luminance Image')
        % subplot(1, 5, 4), imshow(cbImage), title('Blue Chroma Image')
        % subplot(1, 5, 5), imshow(crImage), title('Red Chroma Image')

        % Step 4: Convert crImage into a binary image using a threshold
        threshold = graythresh(crImage);
        imageMask = im2bw(crImage, threshold);
        % figure, subplot(1, 3, 1), imshow(imageMask), title('Binary image (Mask)')

        % Calculate the euler number 
        %(number of objects in the region minus the number of holes in those objects)
        bweuler(imageMask);

        % Step 5: Morphological operations
        morphMask = bwmorph(imageMask, 'open');
        % subplot(1, 4, 2), imshow(morphMask), title('Mask; open')

        se = strel('sphere', 9);
        morphMask = imdilate(morphMask,se);
        %maskMorph = bwmorph(maskMorph, 'close', 1000);
        % subplot(1, 3, 2), imshow(morphMask), title('Morphological operations')

        % Step 6: Combine original image with the mask
        faceMask = originalImage .* morphMask;
        % subplot(1, 3, 3), imshow(faceMask), title('Face Mask')

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
         
    end
    
    %save cell of images
    save 'db1Faces' db1Faces;

    
end