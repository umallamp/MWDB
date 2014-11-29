function [ fileApproxIndex, bitsPerDims, fileSize, reducedFeatures, features, colIndexVector, minValues, maxValues, boundaries, dataSetRegions, reducedDataMatrix ] = getIndexStructure( bitsPerVector, datasetDir )

variance = 99;

% construct the data matrix for all the files
[~, features, dataMatrix, colIndexVector] = getDataMatrix(datasetDir);
[~, colCount] = size(dataMatrix);

% get normalized matrix by computing L2 norm
dataMatrixNorm = sqrt(sum(dataMatrix.^2,2));
dataMatrixNormMatrix = repmat(dataMatrixNorm, [1 colCount]);
dataMatrix = dataMatrix ./ dataMatrixNormMatrix;

% dimensionality reduction
[u, s, v] = svd(dataMatrix);
eigenValues = diag(s);
eigenCSum = cumsum(eigenValues);
eigenImportance = (eigenCSum / eigenCSum(length(eigenCSum))) * 100;
inherantDims = find(eigenImportance <= variance, 1, 'last');
reducedDataMatrix = u(:, 1:inherantDims) * s(1 : inherantDims, 1 : inherantDims);
reducedFeatures = v(1 : inherantDims, :);

% size of reduced data matrix
[rowCount, colCount] = size(reducedDataMatrix);

% calculate the min and max boundaries
minValues = min(reducedDataMatrix);
maxValues = max(reducedDataMatrix);

% array for bits per dimension
bitsPerDims = zeros(1, colCount);

% compute the number of bits for each dimension
remainder = mod(bitsPerVector, colCount);
bitsPerDim = floor(bitsPerVector / colCount);

for index = 1 : colCount
    if(index <= remainder)
        bitsPerDims(index) = bitsPerDim + 1;
    else
        bitsPerDims(index) = bitsPerDim;
    end
end

% compute the vector approximation for each file and add to vector
% approximiation index

[dataSetRegions, boundaries] = getRegions(reducedDataMatrix, minValues, maxValues, bitsPerDims);

% approximation for all files
fileApproxIndex = [];

for fileId = 1 : rowCount
    fileApprox = '';
    for dimId = 1 : colCount
        fileApprox = strcat(fileApprox, dec2bin(dataSetRegions(fileId, dimId), bitsPerDims(dimId)));
    end
    fileApproxIndex = [fileApproxIndex; fileApprox]; 
end

% compute the size of index file
[rowSize, colSize] = size(fileApproxIndex);
fileSize = (rowSize * colSize) / 8;

end

