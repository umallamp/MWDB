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

% approximation for all files
fileApproxIndex = [];

for fileId = 1 : rowCount
    fileApprox = '';
    for dimId = 1 : colCount
        % divide the space into equal partitions
        width = (maxValues(dimId) - minValues(dimId)) / 2^bitsPerDims(dimId);
        
        % if the data point lies in the region < minValue + width
        if(reducedDataMatrix(fileId, dimId) <= minValues(dimId) + width)
            fileApprox = strcat(fileApprox, dec2bin(0, bitsPerDims(dimId)));
        else
             % if the data point lies in the region > maxValue - width
            if(reducedDataMatrix(fileId, dimId) > maxValues(dimId) - width)
            fileApprox = strcat(fileApprox, dec2bin((2^bitsPerDims(dimId) - 1), bitsPerDims(dimId)));
            else
                 % if the data point lies between the regions < minValue +
                 % width and > maxValue - width
                region = 0;
                for boundary = minValues(dimId) + width : width : maxValues(dimId) - width
                    region = region + 1;
                    if(reducedDataMatrix(fileId, dimId) > boundary  && reducedDataMatrix(fileId, dimId) <= (boundary + width))
                        fileApprox = strcat(fileApprox, dec2bin(region, bitsPerDims(dimId)));
                    end
                end
            end
        end
    end
    fileApproxIndex = [fileApproxIndex; fileApprox]; 
end

% compute the size of index file
[rowSize, colSize] = size(fileApproxIndex);
fileSize = (rowSize * colSize) / 8;

end

