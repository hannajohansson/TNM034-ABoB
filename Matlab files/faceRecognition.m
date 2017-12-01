function faceRecognition()%db, image)
    
    % ---------- TA BORT ----------
    load ('dbNormKings');
    db = dbNormKings;
    
    image = imread('normKings/norm_1.jpg');
    % -----------------------------

    % Step 1: Get feature vectors 
    disp('--- Creating eigenfaces.. ---');
    createEigenfacesPCA(db);
    result = compareFace(image);
    
end