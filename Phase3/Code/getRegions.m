function [ regions, boundaries ] = getRegions( reducedMatrix, minValues, maxValues, bitsPerDims )

% size of reduced data matrix
[rowCount, colCount] = size(reducedMatrix);
regions = zeros(rowCount, colCount);

% initialize boundary values
boundaries = zeros(colCount, (2^max(bitsPerDims) + 1));

% compute boundary values for each dimension
for dimId = 1 : length(bitsPerDims)
    width = (maxValues(dimId) - minValues(dimId)) / 2^bitsPerDims(dimId);
    
    % min boundary is - Inf and max boundary is +Inf
    boundaries(dimId, 1) = -1 * Inf;
    boundaries(dimId, (2^bitsPerDims(dimId) + 1)) = Inf;
    
    % compute the boundary values for other regions
    weight = 1;
    for boundaryId = 2 : 2^bitsPerDims(dimId)
        boundaries(dimId, boundaryId) = minValues(dimId) + width * weight; 
        weight = weight + 1;
    end
end

% find the region into which the dimension lies
for fileId = 1 : rowCount
    for dimId = 1 : colCount
        for boundaryId = 1 : 2^bitsPerDims(dimId)
            if(reducedMatrix(fileId, dimId) > boundaries(dimId, boundaryId)  && reducedMatrix(fileId, dimId) <= boundaries(dimId, boundaryId + 1))
                regions(fileId, dimId) = boundaryId - 1;
            end
        end
    end
end
end

