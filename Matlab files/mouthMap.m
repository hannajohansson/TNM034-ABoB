%We need to send variables to the function from faceAlignment


function mouthMap()


%               --------------- Mouth detection ---------------
% MouthMap = Cr^2 * (Cr^2 - eta*Cr/Cb)^2
% eta = 0,95 * 1/n * (sum of all elements in Cr^2 ) /(sum of all elements in Cr/Cb ) 

% Split into separate chanels
y =histeq(iycbcr(:,:,1)); 
cb=histeq(iycbcr(:,:,2));
cr=(iycbcr(:,:,3));

% Create components for equation, has to be normalized to the range 0->1
%   When we work with doubles, the normalization = [0,1] <- now! 
%   When we work with uint8, the normalization = [0,255]
cr2=cr.^2 ;
cr2Norm = ((cr2 -min(cr2(:)))./ ( max(cr2(:) - min(cr2(:))))); 
crcb=cr./cb;
crcbNorm = ((crcb -min(cbcr(:))) ./ ( max(crcb(:) - min(cbcr(:)))));

% Calculate eta  
etaNum = mean2(cr.^2);
etaDenum = mean2(cr(:) ./ cb(:)); 
eta = 0.95  * (etaNum / etaDenum);

% Calculate the mouthMap 
mouthMapC = cr2Norm .* (cr2Norm - (eta.*crcbNorm)).^2;
%mouthMapC = im2bw(mouthMapC, 0.9);
% dilation and erosion
SED = strel('disk', 20, 8); % radius = 15, n(number of segments) = 8
%SED = strel('rectangle', [3,10]);
SEE = strel('disk', 16, 8); % radius = 15, n(number of segments) = 8
%SEE = strel('rectangle', [3,10]); % radius = 15, n(number of segments) = 8


mouthMapCDil = imdilate(im2uint8(mouthMapC), SED);
%mouthMapCEr = imerode(im2uint8(mouthMapC), SE2);


mouthMapDE = imerode(im2uint8(mouthMapCDil), SEE);

mouthLevel = graythresh(image);
mouthMapDELevel = im2bw(mouthMapDE,0.7);
% mouthMapCDil = imdilate(mouthMapC);

% Add facemask to mouthMapDELevel
finalMouthMap = (mouthMapDELevel .* faceMaskEr);

%{
figure;
subplot(2,2,1);
imshow(mouthMapDELevel);
title('mouthMapDELevel'); 

subplot(2,2,2);
imshow(mouthMapDE);
title('mouthMapDE'); 

subplot(2,2,3);
imshow(mouthMapC);
title('mouthMapC'); 

subplot(2,2,4);
imshow(image);
title('image');
%}

end