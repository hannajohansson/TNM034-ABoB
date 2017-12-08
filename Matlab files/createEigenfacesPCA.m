function createEigenfacesPCA(db)
    
    % Step 1: Create variables
    [rows, cols] = size(db); % db or image
    n = 300 * 400; % Facial image dimension
    M = cols; % Number of traning images in db, M << n
    K = cols; % Number of Eigenfaces used, K <= M
    xiSum = 0;
    xiVec = zeros(n,M);
    
    % Loop over every image in db
    for k = 1:M
        
        % Step 2: Create gray image with only one channel
        originalImage = im2double(db{k});
        grayNormImage = rgb2gray(originalImage); 
        
        % Step 3: Represent each image, Ii, as a n.vector xi
        xiVec(:,k) = grayNormImage(:);
        xiSum = xiSum + xiVec(:,k);
    
    end 

    % Step 4: Find mean face (the average face vector)
    meanFace = 1/M * xiSum; 
    save 'meanFace' meanFace;
    
    phiVec = zeros(n,M);
    
    for k = 1:M
        
        % Step 5: Subtract the mean face for each face vector xi
        phiVec(:,k) = xiVec(:,k) - meanFace;

    end 
    
    % Step 6: Find the covariance matrix, C = A * A' 
    % We have to calculate C = A' * A (size MxM) because of size issues
    A = phiVec;
    C = A.' * A; % returns M eigenvectors, vi (size Mx1)
    [V, D] = eig(C); % V is the eigenvectors, D is the eigenvalues
        
    % Step 7: Compute the M largest eigenvectors ui for the nxn matrix A*A' 
    ui = A * V; % M eigenvectors ui
    ui = ui/norm(ui); % Normalize ui
    save 'ui' ui;
    
    % Step 8: Reshape the eigenvectors into Eigenfaces (matrix)    
    % Feature vector: (large omega) wi? = [w1; w2; ...; wK]
    weights = ui.' * phiVec;
    save 'weights' weights;

end