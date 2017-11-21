%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function id = tnm034(im) 
%
% im: Image of unknown face, RGB-image in uint8format in the
% range [0,255]
%
% id: The identity number (integer) of the identified person,

% i.e.?1?, ?2?,...,?16?for the persons belonging to ?db1? 
% and ?0?for allother faces.

%
% Your program code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('--- Reading images.. ---');
imageRead();
disp('--- Editing images.. ---');
editImages();


%disp('-----------------------------------------------');
%disp('  PART 1: Face detection ');
%disp('-----------------------------------------------');
% PART 1: Face detection 
    %Find face mask
    
disp('--- Detecting face.. ---');
faceDetection();


%disp('-----------------------------------------------');
%disp('  PART 2: Face alignment ');
%disp('-----------------------------------------------');
disp('--- Aligning the face.. ---');
faceAlignment();


%disp('-----------------------------------------------');
%disp('  PART 3: Appearence Normalization ');
%disp('-----------------------------------------------');
% PART 3: Appearance Normalization
    % Crop and normalize for 
        % Scale +-10%
        % Rotation +-5?
        % Tone value +-30%

        
%disp('-----------------------------------------------');
%disp('  PART 4: Feature Description ');
%disp('-----------------------------------------------');
% PART 4: Description
    % Creating Eigenfaces
    % Using PCA (Principle Component Analysis)???

%disp('-----------------------------------------------');
%disp('  PART 5: Feature Extraction ');
%disp('-----------------------------------------------');
% PART 5: Feature Extraction
    % Plot feature description for all images in db  

%disp('-----------------------------------------------');
%disp('  PART 6: Matching ');
%disp('-----------------------------------------------');
% PART 6: Matching
    % Compare an image with the db and find the closest match
    % Decide if the closest match is close enough

