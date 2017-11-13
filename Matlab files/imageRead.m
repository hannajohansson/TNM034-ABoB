function imageRead() 
% Read all images from db0 and put them in cell 

% db0
numfiles0 = 4;
db0Images = cell(1, numfiles0);
    for k = 1:numfiles0
      myfilename = sprintf('images/db0/db0_%d.jpg', k);
      db0Images{k} = importdata(myfilename);
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
      %imshow(db0Images{k})
    end
    for l = 10:numfiles1
      myfilename = sprintf('images/db1/db1_%d.jpg', l);
      db1Images{l} = importdata(myfilename);
      %imshow(db0Images{k})
    end
%save cell of images
save 'db1Images' db1Images;    

end
