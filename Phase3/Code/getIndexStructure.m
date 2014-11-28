function [ fileApproxIndex, bitsPerDims, fileSize ] = getIndexStructure( bitsPerVector, datasetDir )

variance = 99;

% construct the data matrix for all the files
[~, ~, dataMatrix] = getDataMatrix(datasetDir);
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

% size of reduced data matrix
[rowCount, colCount] = size(reducedDataMatrix);

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

% approximation for all files
fileApproxIndex = [];

for fileId = 1 : rowCount
    fileApprox = '';
    for dimId = 1 : colCount
        % divide the space into equal partitions
        partition = 1 / bitsPerDims(dimId);
        for bit = 0 : (bitsPerDims(dimId) - 1)
            % determine into which partition the point falls into
            if((bit * partition) <= dataMatrix(fileId, dimId) && dataMatrix(fileId, dimId) <= ((bit + 1) * partition))
                fileApprox = strcat(fileApprox, dec2bin(bit, bitsPerDims(dimId)));
            end
        end
    end
    fileApproxIndex = [fileApproxIndex; fileApprox]; 
end

fileSize = length(fileApproxIndex) / 8;

end

