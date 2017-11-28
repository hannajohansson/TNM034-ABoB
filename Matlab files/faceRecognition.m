function [result] = faceRecognition(db, image)
    
    % Step 1: Get feature vectors 
    featureVector = createEigenfacesPCA(db);
    weightQuery = createEigenfacesPCA(image);
    
    [rows, cols] = size(featureVector);
    M = cols;
    
    % Step 2: Using eigenfaces for face recognition
    % Find feature vector for unknown face - aka weightQuery
    % ei = Distance measure between queryImage to each 
    % feature vec for the M faces
    for k = 1:M
        ei = abs(weightQuery - featureVector(:,k))
    end
    
    % Step 3: Find the smallest ei
    eiMin = min(ei);
    
    % Step 4: Define a threshold for acceptable distance
    threshold = 0,5; % <-- example
    
    % Step 5: Check if image is in database
    if eiMin <= threshold
       disp('queryImage is person eiMin')
       % result = k; ??
       disp(result)
    else 
       disp('queryImage is not in database')
       result = 0;
       disp(result)
    end
    
    % ---------- WHAT SHOULD WE DO WITH THIS?? ----------
    % ----------- HELP PLEASE: ASK DANIEL!!! ------------
    
    %wuSum = 0;
    %for k = 1:K
    %my is the mean face for the training set
    %ui is the eigenfaces
         
        %wuTemp = (featureVector(k,:) .* ui(:,k));
        %wuSum = wuSum + wuTemp;
        
    %end    
   
    %I = my + wuSum;
    
    % ---------------------------------------------------

end