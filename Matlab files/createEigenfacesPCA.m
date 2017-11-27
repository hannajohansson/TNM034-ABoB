function createEigenfacesPCA()
    
    % --- Test with dbNormKings --------------------------------
   
    % Variables
    n = 300 * 400; % Facial image dimension
    M = 3; % Number of traning images in dbNormKings
    K = 3; % Number of Eigenfaces used
    % M << n, K <= M
    
    xiSum = 0;
    xiVec = zeros(n,M);
    
    for k = 1:M

        % Step 1: Collect M training images of faces, I1, I2, ..., Im
        load ('dbNormKings');
        originalImage = im2double(dbNormKings{k});
        grayNormImage = rgb2gray(originalImage); 
        
        % Step 2: Represent each image, Ii, as a n.vector xi
        xiVec(:,k) = grayNormImage(:);
        xiSum = xiSum + xiVec(:,k);
    
    end 

    % -------------- db1Images ---------------------------------
    % Bildera måste vara 300x400 innan man kan testa detta!
    %{
    % Variables
    n = 300 * 400; % Facial image dimension
    M = 16; % Number of traning images in db1
    K = 16; % Number of Eigenfaces used
    % M << n, K <= M
    
    xiSum = 0;
    xiVec = zeros(n,M);
    
    for k = 1:M

        % Step 1: Collect M training images of faces, I1, I2, ..., Im
        load ('db1Images');
        originalImage = im2double(db1Images{k});
        grayNormImage = rgb2gray(originalImage); 
        
        % Step 2: Represent each image, Ii, as a n.vector xi
        xiVec(:,k) = grayNormImage(:);
        xiSum = xiSum + xiVec(:,k);
    
    end 
    %}
    % ---------------------------------------------------------

    % Step 3: Find mean face (the average face vector)
    my = 1/M * xiSum;
    phiVec = zeros(n,M);
    
    for k = 1:M
        
        % Step 4: Subtract the mean face, my, for each face vector xi
        phiVec(:,k) = xiVec(:,k) - my;
        
    end 
    
    % Step 5: Find the covariance matrix, C = A * A' 
    % We have to calculate C = A' * A (size MxM) because of size issues
    A = phiVec;
    C = A.' * A; % returns M eigenvectors, vi (size Mx1)
    [V, D] = eig(C); % V is the eigenvectors, D is the eigenvalues
        
    % Step 6: Compute the M largest eigenvectors ui for the nxn matrix A*A' 
    ui = A * V; % M eigenvectors ui

    % Step 7: Reshape the eigenvectors into Eigenfaces (matrix)    
    % Feature vector: (large omega) ? = [w1; w2; ...; wK]
    weights = ui.' * phiVec;
    % featureVector = weights
    wuSum = 0;
    
    for k = 1:K
        
        wuTemp = (weights(k,:) .* ui(:,k));
        wuSum = wuSum + wuTemp;
        
    end    
    
    I = my + wuSum;

end