function createEigenfacesPCA()
    
    % --- REMOVE AND LOAD LATER ---
    % read normKings
    numfiles0 = 3;
    dbNormKings = cell(1, numfiles0);
        for k = 1:numfiles0
          myfilename = sprintf('normKings/norm_%d.jpg', k);
          dbNormKings{k} = importdata(myfilename);
          imshow(dbNormKings{k})
        end
        
    %save cell of images
    save 'dbNormKings' dbNormKings;
    % ------------------------------
    
    % Variables
    n = 300 * 400; % Facial image dimension
    M = 16; % Number of traning images in db1
    k = 16; % ??? Number of Eigenfaces used
    % M << n, k <= M
    
    xiSum = 0;
    
    for k = 1:3

        % Step 1: Collect M training images of faces, I1, I2, ..., Im
        load ('dbNormKings');
        originalImage = im2double(dbNormKings{k});
        grayNormImage = rgb2gray(originalImage); 
        
        % Step 2: Represent each image, Ii, as a n.vector xi
        xi = grayNormImage(:);
        xiSum = xiSum + xi; 
    
    end 

    % Step 3: Find mean face (the average face vector)
    my = 1/M * xiSum;
    
    for k = 1:3
        
        % Step 4: Subtract the mean face, my, for each face vector xi
        %lägg in phii för varje xi i en array A
        %xi(k) = grayNormImage(:);
        %phii(k) = xi(k) - my;
        %[1,3] = size(A); 
        %A[k-1] = phii(k);
   
        
    end
    
end