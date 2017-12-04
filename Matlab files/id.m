%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function id = tnm034(im) 
%
% im: Image of unknown face, RGB-image in uint8format in the
% range [0,255]
%
% id: The identity number (integer) of the identified person,

% i.e.?1?, ?2?,...,?16?for the persons belonging to ?db1? 
% and ?0? for allother faces.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

im = imread('images/db0/db0_4.jpg');

%% Run the face detection for all images in the database

%-----------------------------------------------------
%       PART 0: Read and edit images
%-----------------------------------------------------
disp('--- Reading images.. ---');
imageRead();

%-----------------------------------------------------
%    Loop over db and do each step for each image
%-----------------------------------------------------

    % Load images
    load ('db1Images');
    [rows, length] = size(db1Images);
    
    disp('--- Processing image.. ---');
    for k = 1:length
        disp(k);
        %Take one image at a time from the db
        image = db1Images{k};
        editedImage = editImages(image);

        %-----------------------------------------------------
        %       PART 1: Face detection
        %-----------------------------------------------------
        %Find face mask 
        faceMask = faceDetection(editedImage); 

        %-----------------------------------------------------
        %       PART 2: Face alignment
        %-----------------------------------------------------
        faceAlignment(editedImage, faceMask);

        %-----------------------------------------------------
        %       PART 3: Appearance Normalization
        %-----------------------------------------------------
        % Crop and normalize for 
            % Scale +-10%
            % Rotation +-5?
            % Tone value +-30%
    end
    disp('--- Database completly processed. ---');
    
%% Run the face detection for the image im to be compared with the db


disp('--- Process the input image im.. ---');
editedImage = editImages(im);
faceMask = faceDetection(editedImage); 
[leftEyeCoords, rightEyeCoords, mouthCoords] = faceAlignment(editedImage, faceMask);
%Appearence Normalization

%% Match the input image with the database images

%-----------------------------------------------------
%       PART 4: Feature Description
%-----------------------------------------------------     
% Creating Eigenfaces
% Using PCA (Principle Component Analysis)
        
%-----------------------------------------------------
%       PART 5: Feature Extraction
%-----------------------------------------------------  
% Plot feature description for all images in db  

%-----------------------------------------------------
%       PART 6: Matching
%----------------------------------------------------- 
% Compare an image with the db and find the closest match
% Decide if the closest match is close enough

%result = faceRecognition(databas, bild);