function [ fileApproxIndex, bitsPerDims, fileSize, reCreateMatrix, features, colIndexVector, minValues, maxValues, boundaries, dataSetRegions, reducedDataMatrix ] = getIndexStructure( bitsPerVector, datasetDir )


% construct the data matrix for all the files
[~, features, dataMatrix, colIndexVector] = getDataMatrix(datasetDir);

% get normalized matrix by computing L2 norm
dataMatrix = getNormalizedMatrix(dataMatrix);

% reducedDataMatrix = dataMatrix;
% reducedFeatures = features;

[ reducedDataMatrix, reCreateMatrix ] = getReducedMatrix( dataMatrix );

% size of reduced data matrix
[rowCount, totalDims] = size(reducedDataMatrix);

% calculate the min and max boundaries
minValues = min(reducedDataMatrix);
maxValues = max(reducedDataMatrix);
% minValues = zeros(colCount);
% maxValues = ones(colCount);

% array for bits per dimension
bitsPerDims = ones(1, totalDims) * bitsPerVector;

% % compute the number of bits for each dimension
% remainder = mod(bitsPerVector, colCount);
% bitsPerDim = floor(bitsPerVector / colCount);
% 
% for index = 1 : colCount
%     if(index <= remainder)
%         bitsPerDims(index) = bitsPerDim + 1;
%     else
%         bitsPerDims(index) = bitsPerDim;
%     end
% end

% compute the vector approximation for each file and add to vector
% approximiation index

[dataSetRegions, boundaries] = getRegions(reducedDataMatrix, minValues, maxValues, bitsPerDims);

% approximation for all files
fileApproxIndex = [];

for fileId = 1 : rowCount
    fileApprox = '';
    for dimId = 1 : totalDims
        fileApprox = strcat(fileApprox, dec2bin(dataSetRegions(fileId, dimId), bitsPerDims(dimId)));
    end
    fileApproxIndex = [fileApproxIndex; fileApprox]; 
end

% compute the size of index file
[rowSize, ~] = size(fileApproxIndex);
fileSize = (rowSize * totalDims * bitsPerVector) / 8;

end

