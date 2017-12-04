function [cropedImage] = cropImage(eyeLeft, eyeRight, image)

    % Steg 1: Rotation
    % J = imrotate(I,-1,'bilinear','crop');

    nar = eyeLeft.y - eyeRight.y;
    mot = eyeLeft.x - eyeRight.x;
    hyp = sqrt(abs(nar).^2 + abs(mot).^2);
    deltaX = 200;
    theta = atand(nar/mot);

    rotatedImage = imrotate(image,theta,'bilinear','crop');

    % Steg 2: Scale
    %J = imresize(I, 0.5);
    scaleFactor = deltaX/hyp;
    scaledImage = imresize(roatedImage, scaleFactor);

    % Steg 3: Crop
    %X2 = imcrop(X,map,[30 30 50 75]);
    cropedImage = (scaledImage, [(eyeLeft.x-50) (eyeLeft.y-100) 300 400]);

end
