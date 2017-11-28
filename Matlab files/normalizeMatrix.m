% matrix = matrix to be normalized
% [x, y] = e.g. [0, 255]

function [normalized]= normalizeMatrix(matrix, x, y)

     % Normalize to [0, 1]:
     m = min(matrix(:));
     range = max(matrix(:)) - m;
     matrix = (matrix - m) ./ range;

     % Then scale to [x,y]:
     range2 = y - x;
     normalized = (matrix .* range2) + x;
     
end
     
     
