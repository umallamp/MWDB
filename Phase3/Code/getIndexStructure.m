function [ vectorApproxIndex, bitsPerDims, fileSize ] = getIndexStructure( bitsPerVector, datasetDir )

% construct the data matrix for all the files
[~, ~, dataMatrix] = getDataMatrix(datasetDir);
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

% compute the vector approximation for each file and add to vector
% approximiation index
vectorApproxIndex = '';
for fileId = 1 : rowCount
    fileApprox = '';
    for dimId = 1 : colCount
        % divide the space into equal partitions
        partition = 1 / bitsPerDims(dimId);
        for bit = 0 : (bitsPerDims(dimId) - 1)
            % determine into which partition the point falls into
            if((bit * partition) <= dataMatrix(fileId, dimId) && dataMatrix(fileId, dimId) <= ((bit + 1) * partition))
                fileApprox = strcat(fileApprox, dec2bin(bit));
            end
        end
    end
    vectorApproxIndex = strcat(vectorApproxIndex, fileApprox); 
end

fileSize = length(vectorApproxIndex) / 8;

end

