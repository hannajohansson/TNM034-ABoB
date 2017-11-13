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


%disp('-----------------------------------------------');
%disp('  PART 1: Face detection ');
%disp('-----------------------------------------------');
% PART 1: Face detection 
    %Find face mask
    
disp('--- Detecting face.. ---');
detection();


%disp('-----------------------------------------------');
%disp('  PART 2: Face alignment ');
%disp('-----------------------------------------------');
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


%disp('-----------------------------------------------');
%disp('  PART 5: Feature Extraction ');
%disp('-----------------------------------------------');
% PART 5: Feature Extraction


%disp('-----------------------------------------------');
%disp('  PART 6: Matching ');
%disp('-----------------------------------------------');
% PART 6: Matching

