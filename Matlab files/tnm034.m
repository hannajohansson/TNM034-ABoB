function [id] = tnm034(im)

    % im: Image of unknown face, RGB-image in uint8 format in the range [0,255]
    % id: The identity number (integer) of the identified person
    
    % RUN "processDB" ONE TIME BEFORE THIS FUNCTION
    
    close all;

    % REMOVE LATER
    im = imread('testIm/db1_09_combination.jpg');

    % Run the face detection for the image im to be compared with the db
    disp('--- Processing the input image.. ---');
    editedImage = editImages(im);
    faceMask = faceDetection(editedImage);
    [leftEyeCoordsIm, rightEyeCoordsIm] = faceAlignment(editedImage, faceMask);
    cropedIm = cropImage(leftEyeCoordsIm, rightEyeCoordsIm, editedImage);

    % Match the input image with the database images
    id = compareFace(cropedIm);

end