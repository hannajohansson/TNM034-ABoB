function imageRead() 
%----------------------------------------------------------------
%       Read all images from db1 and put them in a cell 
%----------------------------------------------------------------
    numfiles1 = 16;
    db1Images = cell(1, numfiles1);
        %images < 9 is syntaxed with 01, 02...
        for l = 1:9 
          myfilename = sprintf('images/db1/db1_0%d.jpg', l);
          db1Images{l} = importdata(myfilename);
        end
        %images > 10 is syntaxed with 10, 11...
        for l = 10:numfiles1
          myfilename = sprintf('images/db1/db1_%d.jpg', l);
          db1Images{l} = importdata(myfilename);
        end
        
    %save cells
    save 'db1Images' db1Images;   

end
