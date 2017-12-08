function [editedImage] = editImages(image)

    originalImage = im2double(image);

    % Step 1: Convert to gray so we can get the mean luminance.
    grayImage = rgb2gray(originalImage);
    J = imadjust(grayImage); 
    %J = imadjust(grayImage,[],[]);

    % Step 2: Extract the individual red, green, and blue color channels.
    redChannel = originalImage(:, :, 1);
    greenChannel = originalImage(:, :, 2);
    blueChannel = originalImage(:, :, 3);

    % Step 3: Mean 
    meanRed = mean2(redChannel);
    meanGreen = mean2(greenChannel);
    meanBlue = mean2(blueChannel); 
    meanGray = mean2(J);

    % Step 4: Make all channels have the same mean
    redChannel = (redChannel * meanGray / meanRed);
    greenChannel = (greenChannel * meanGray / meanGreen);
    blueChannel = (blueChannel * meanGray / meanBlue);

    % Step 5: Recombine separate color channels into a single, true color RGB image.
    editedImage = cat(3, redChannel, greenChannel, blueChannel);
    editedImage = min(editedImage, 1);
    
    % PLOTS
    %{
    figure, subplot(1,4,1), imshow(originalImage);
    subplot(1,4,2), imshow(J);
    subplot(1,4,4), imshow(editedImage);
    %}
end