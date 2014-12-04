function [ dataMatrix ] = getNormalizedMatrix( dataMatrix )

[~, colCount] = size(dataMatrix);

% get normalized matrix by computing L2 norm
dataMatrixNorm = sqrt(sum(dataMatrix.^2,2));
dataMatrixNormMatrix = repmat(dataMatrixNorm, [1 colCount]);
dataMatrix = dataMatrix ./ dataMatrixNormMatrix;

end

