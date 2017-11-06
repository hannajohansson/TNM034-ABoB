
% Read all images from db0 and put them in cell 
numfiles = 4;
db0Images = cell(1, numfiles);

for k = 1:numfiles
  myfilename = sprintf('images/db0/db0_%d.jpg', k);
  db0Images{k} = importdata(myfilename);
  imshow(db0Images{k})
end
