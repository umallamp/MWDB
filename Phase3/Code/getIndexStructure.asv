function [ wordFileVectors, bitsPerDims ] = getIndexStructure( bitsPerVector, datasetDir )

% construct the data matrix for all the files
dataMatrix = getDataMatrix(datasetDir);
[rowCount, colCount] = size(dataMatrix);

% get normalized matrix
dataMatrix = getNormalizedMatrix(dataMatrix);

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

end

