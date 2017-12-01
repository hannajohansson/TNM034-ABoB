function [result] = compareFace(image)

    load ('weights');
    load ('meanFace');
    load ('ui');
    
    n = 300 * 400; % Facial image dimension
    
    % Step 1: Create gray image with only one channel
    originalImage = im2double(image);
    grayNormImage = rgb2gray(originalImage);
   
    % Step 2: Represent the image, as a n.vector xi
    xi = grayNormImage(:);    
    
    % Step 3: Subtract the mean face
    phi = xi - meanFace;

    % Step 4: Calculate the weight for image
    weightQuery = ui.' * phi;

    [rows, cols] = size(weights);
    M = cols;
    
    % Step 5: Using eigenfaces for face recognition
    % Find feature vector for unknown face - aka weightQuery
    % ei = Distance measure between queryImage to each 
    % feature vec for the M faces
    for k = 1:M
        ei = abs(weightQuery - weights(:,k));
    end
    
    % Step 6: Find the smallest ei
    eiMin = min(ei)
    
    % Step 7: Define a threshold for acceptable distance
    threshold = 0.5; % <-- example
    
    % Step 8: Check if image is in database
    if eiMin <= threshold
       disp('queryImage is person:')
       result = find(ei == min(ei));
       disp(result)
    else 
       disp('queryImage is not in database')
       result = 0;
       disp(result)
    end
    
end