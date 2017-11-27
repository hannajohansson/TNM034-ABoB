function imageRead() 
% Read all images from db0 and put them in cell 

    % db0
    numfiles0 = 4;
    db0Images = cell(1, numfiles0);
        for m = 1:numfiles0
          myfilename = sprintf('images/db0/db0_%d.jpg', m);
          db0Images{m} = importdata(myfilename);
          %imshow(db0Images{k})
        end
        
    %save cell of images
    save 'db0Images' db0Images;

    % db1
    numfiles1 = 16;
    db1Images = cell(1, numfiles1);
        for l = 1:9
          myfilename = sprintf('images/db1/db1_0%d.jpg', l);
          db1Images{l} = importdata(myfilename);
          %figure, imshow(db1Images{l})
        end
        for l = 10:numfiles1
          myfilename = sprintf('images/db1/db1_%d.jpg', l);
          db1Images{l} = importdata(myfilename);
          %figure, imshow(db1Images{l})
        end
        
    %save cell of images
    save 'db1Images' db1Images;   
    
    % --- TEST WITH FEWER IMAGES - REMOVE LATER -------------
    % read normKings
    numfiles2 = 3;
    dbNormKings = cell(1, numfiles2);
        for m = 1:numfiles2
          myfilename = sprintf('normKings/norm_%d.jpg', m);
          dbNormKings{m} = importdata(myfilename);
          %figure, imshow(dbNormKings{k})
        end
        
    %save cell of images
    save 'dbNormKings' dbNormKings;
    % --------------------------------------------------------

end
