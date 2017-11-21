function editImages()

    % Step 1: Load images
    load ('db1Images');

    for k = 1:16

        originalImage = im2double(db1Images{k});
        % figure;
        % subplot(1, 2, 1), imshow(originalImage), title('Original image');

        % Step 2: Convert to gray so we can get the mean luminance.
        grayImage = rgb2gray(originalImage);

        % Step 3: Extract the individual red, green, and blue color channels.
        redChannel = originalImage(:, :, 1);
        greenChannel = originalImage(:, :, 2);
        blueChannel = originalImage(:, :, 3);

        % Step 4: Mean 
        meanRed = mean2(redChannel);
        meanGreen = mean2(greenChannel);
        meanBlue = mean2(blueChannel); 
        meanGray = mean2(grayImage);

        % Step 5: Make all channels have the same mean
        redChannel = (redChannel * meanGray / meanRed);
        greenChannel = (greenChannel * meanGray / meanGreen);
        blueChannel = (blueChannel * meanGray / meanBlue);

        % Step 6: Recombine separate color channels into a single, true color RGB image.
        editedImage = cat(3, redChannel, greenChannel, blueChannel);
        % subplot(1, 2, 2), imshow(editedImage), title('Edited image');

        db1Images{k} = editedImage;

    end
    
    %save cell of images
    save 'db1Images' db1Images;  

end