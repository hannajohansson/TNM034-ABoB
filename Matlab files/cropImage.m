function [cropedImage] = cropImage(leftEyeCoords, rightEyeCoords, editedImage)

    % Variables
    nar = leftEyeCoords(1,2) - rightEyeCoords(1,2);
    mot = leftEyeCoords(1,1) - rightEyeCoords(1,1);
    hyp = sqrt(abs(nar).^2 + abs(mot).^2);
    theta = atand(nar/mot);
    deltaX = 140;
    
    % Step 1: Rotation
    rotatedImage = imrotate(editedImage, theta, 'bilinear', 'crop');

    % Step 2: Scale
    scaleFactor = deltaX/hyp;
    scaledImage = imresize(rotatedImage, scaleFactor);
    
    % Scale eye coordinates
    leftEyeCoords(1,1) = leftEyeCoords(1,1) * scaleFactor;
    leftEyeCoords(1,2) = leftEyeCoords(1,2) * scaleFactor;
    
    % Step 3: Crop
    cropedImage = imcrop(scaledImage, [(leftEyeCoords(1,1)-50) (leftEyeCoords(1,2)-80) 299 399]);
    
    [rows, cols, dim] = size(cropedImage);
    
    % Pad with zeros if image is smaller
    if cols < 301
        cropedImage(:,300,:) = 0;
    end

    if rows < 401
        cropedImage(400,:,:) = 0;
    end

    %% PLOTS
    figure, subplot(1,3,1), imshow(rotatedImage);
    axis on
    
    subplot(1,3,2), imshow(scaledImage);
    axis on
    
    subplot(1,3,3), imshow(cropedImage);
    axis on
    
end
