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

    % PLOTS
    figure, subplot(1,4,1), imshow(editedImage), title('Original image');
    axis on
    
    subplot(1,4,2), imshow(rotatedImage), title('Rotated image');
    axis on
    
    subplot(1,4,3), imshow(scaledImage), title('Scaled image');
    axis on
    
    subplot(1,4,4), imshow(cropedImage), title('Cropped image');
    axis on
    
    
end
