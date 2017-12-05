function [cropedImage] = cropImage(leftEyeCoords, rightEyeCoords, editedImage)

    % Steg 1: Rotation
    % J = imrotate(I,-1,'bilinear','crop');

    nar = leftEyeCoords(1,2) - rightEyeCoords(1,2);
    mot = leftEyeCoords(1,1) - rightEyeCoords(1,1);
    hyp = sqrt(abs(nar).^2 + abs(mot).^2);
    deltaX = 140;
    theta = atand(nar/mot);

    rotatedImage = imrotate(editedImage, theta, 'bilinear', 'crop');
    figure, subplot(1,3,1), imshow(rotatedImage);
    axis on
    % Steg 2: Scale
    %J = imresize(I, 0.5);
    scaleFactor = deltaX/hyp;
    scaledImage = imresize(rotatedImage, scaleFactor);
    subplot(1,3,2), imshow(scaledImage);
    axis on
 
    
    % Steg 3: Crop
    %I2 = imcrop(I,[75 68 130 112]);
    cropedImage = imcrop(scaledImage, [(leftEyeCoords(1,1)-50) (leftEyeCoords(1,2)-80) 300 400]);
    %cropedImage = imcrop(scaledImage, [0 0 200 100]);
    subplot(1,3,3), imshow(cropedImage);
    axis on
end
