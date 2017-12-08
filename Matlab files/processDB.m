% RUN THIS FUNCTION ONE TIME BEFORE "TNM034" TO GATHER ALL THE NECCESARY INFORMATION
function processDB()

    % Run the face detection for all images in the database
    %-----------------------------------------------------
    %       PART 0: Read and edit images
    %-----------------------------------------------------
    disp('--- Reading images.. ---');
    imageRead();

    % Load images
    load ('db1Images');
    [rows, length] = size(db1Images);

    save 'cropedImages' db1Images;
    
    %-----------------------------------------------------
    %    Loop over db and do each step for each image
    %-----------------------------------------------------
    disp('--- Processing image.. ---');
    for k = 1:length
        
        %Take one image at a time from the db
        disp(k);
        image = db1Images{k};
        editedImage = editImages(image);

        %-----------------------------------------------------
        %       PART 1: Face detection
        %-----------------------------------------------------
        faceMask = faceDetection(editedImage); 

        %-----------------------------------------------------
        %       PART 2: Face alignment
        %-----------------------------------------------------
        [leftEyeCoords, rightEyeCoords] = faceAlignment(editedImage, faceMask);

        %-----------------------------------------------------
        %       PART 3: Appearance Normalization
        %-----------------------------------------------------
        cropedImage = cropImage(leftEyeCoords, rightEyeCoords, editedImage);
        cropedImages{k} = cropedImage;
        
    end
    disp('--- Database completly processed. ---');

    %-------------------------------------------------------------------
    %       PART 4: Feature Description, Feature Extraction, Matching
    %-------------------------------------------------------------------     
    disp('--- Creating eigenfaces.. ---');
    createEigenfacesPCA(cropedImages);

end