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
    ei = zeros(1,M);
    
    % Step 5: Using eigenfaces for face recognition
    % Find feature vector for unknown face - aka weightQuery
    % ei = Distance measure between queryImage to each 
    % feature vec for the M faces
    for k = 1:M
        ei(k) = norm(weightQuery - weights(:,k));
    end
    ei
    % Step 6: Find the smallest ei
    eiMin = min(ei);
    
    % Step 7: Define a threshold for acceptable distance
    threshold = 25; % <-- example
    
    % Step 8: Check if image is in database
    if eiMin <= threshold
       result = find(ei == min(ei));
    else 
       result = 0;
    end

end