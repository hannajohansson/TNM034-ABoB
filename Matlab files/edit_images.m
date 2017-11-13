function edit_images()

% Step 1: Load images
load ('db1Images');

for k = 1:16
    
    original_image = im2double(db1Images{k});
    figure;
    subplot(1, 3, 1), imshow(original_image);

    % Step 2: Convert to gray so we can get the mean luminance.
    gray_image = rgb2gray(original_image);

    % Step 3: Extract the individual red, green, and blue color channels.
    red_channel = original_image(:, :, 1);
    green_channel = original_image(:, :, 2);
    blue_channel = original_image(:, :, 3);

    % Step 4: Mean 
    meanRed = mean2(red_channel);
    meanGreen = mean2(green_channel);
    meanBlue = mean2(blue_channel); 
    meanGray = mean2(gray_image);

    % Step 5: Make all channels have the same mean
    red_channel = (red_channel * meanGray / meanRed);
    green_channel = (green_channel * meanGray / meanGreen);
    blue_channel = (blue_channel * meanGray / meanBlue);

    % Step 6: Recombine separate color channels into a single, true color RGB image.
    edited_image = cat(3, red_channel, green_channel, blue_channel);
    subplot(1, 3, 2), imshow(edited_image);
    
    db1Images{k} = edited_image;
    
end

save 'db1Images' db1Images;  

end