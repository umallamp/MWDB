function [ neighbours, vectorsExpanded, reducedQueryVector ] = getOptimalNearestNeighbours( queryWordFile, neighbourCount, features, colIndexVector, reCreateMatrix, minValues, maxValues, bitsPerDims, boundaries, dataSetRegions, reducedDataMatrix )

[totalFileCount, ~] = size(reducedDataMatrix);

% represents query as vector by counting the number of unique words
queryVector = zeros(1, length(features));

% get query vector
for featureId = 1 : length(features)
    queryVector(featureId) = sum(ismember(queryWordFile(:, colIndexVector), features(featureId, :),'rows'));
end

queryVector = queryVector / norm(queryVector);

% get reduced query vector and regions for dimensions
reducedQueryVector = queryVector * reCreateMatrix;
% reducedQueryVector = queryVector;
queryRegions = getRegions(reducedQueryVector, minValues, maxValues, bitsPerDims);

[ lowerBoundsHeap ] = phaseOne( reducedQueryVector, dataSetRegions, queryRegions, boundaries, totalFileCount, neighbourCount );
[ neighbours, vectorsExpanded ] = phaseTwo(lowerBoundsHeap, reducedDataMatrix, neighbourCount, reducedQueryVector);

end


function [ lowerBoundsHeap ] = phaseOne( reducedQueryVector, dataSetRegions, queryRegions, boundaries, totalFileCount, neighbourCount )
    distance = Inf;
    neighbours = initCandidate(neighbourCount);
    lowerBoundsHeap = [];

    for fileId = 1 : totalFileCount
        [lowerBound, upperBound] = getBounds(reducedQueryVector, queryRegions, boundaries, dataSetRegions(fileId, :));
        if(lowerBound <= distance)
            [distance, neighbours] = insertCandidate(upperBound, fileId, neighbourCount, neighbours);
            lowerBoundsHeap = [ lowerBoundsHeap; [fileId lowerBound] ];
        end
    end
    [~, order] = sort(lowerBoundsHeap(:,2));
    lowerBoundsHeap = lowerBoundsHeap(order, :);
end

function [ neighbours, vectorsExpanded ] = phaseTwo(lowerBoundsHeap, reducedDataMatrix, neighbourCount, reducedQueryVector)
    count = 1;
    vectorsExpanded = 0;
    distance = Inf;
    neighbours = initCandidate(neighbourCount);

    fileId = lowerBoundsHeap(count, 1);
    lowerBound = lowerBoundsHeap(count, 2);
    
    while(lowerBound < distance)
        count = count + 1;
        vectorsExpanded = vectorsExpanded + 1;
        [distance, neighbours] = insertCandidate(norm(reducedDataMatrix(fileId, :) - reducedQueryVector), fileId, neighbourCount, neighbours);
        fileId = lowerBoundsHeap(count, 1);
        lowerBound = lowerBoundsHeap(count, 2);
    end
end

function [ neighbours ] = initCandidate(neighbourCount)
    % initialize variables for query processing
    neighbours = zeros(neighbourCount, 2);
    neighbours(:, 2) = Inf(neighbourCount, 1);
end

function [ maxDistance, neighbours ] = insertCandidate(distance, fileId, neighbourCount, neighbours)
if(distance < neighbours(neighbourCount, 2))
    % insert the candidate and the distance
    neighbours(neighbourCount, 1) = fileId;
    neighbours(neighbourCount, 2) = distance;
    
    % sort neighbours based on distance
    [~, order] = sort(neighbours(:,2));
    neighbours = neighbours(order, :);
end
maxDistance = neighbours(neighbourCount, 2);
end

function [ lowerBound, upperBound] = getBounds(reducedQueryVector, queryRegions, boundaries, dataSetRegions)

lowerBound = 0;
upperBound = 0;

for dimId = 1 : length(reducedQueryVector)
    % L2 metric for calculating lower bound and upper bound
    % if data point lies left of query point
    if(dataSetRegions(dimId) < queryRegions(dimId))
        lowerBound = lowerBound + (reducedQueryVector(dimId) - boundaries(dataSetRegions(dimId) + 2))^2;
        upperBound = upperBound + (reducedQueryVector(dimId) - boundaries(dataSetRegions(dimId) + 1))^2;
    end
    % if data point lies in the same region
    if(dataSetRegions(dimId) == queryRegions(dimId))
        lowerBound = lowerBound + 0;
        upperBound = upperBound + max((reducedQueryVector(dimId) - boundaries(dataSetRegions(dimId) + 1)), (boundaries(dataSetRegions(dimId) + 2) - reducedQueryVector(dimId)))^2;
    end
    % if data point lies in the right region
    if(dataSetRegions(dimId) > queryRegions(dimId))
        lowerBound = lowerBound + (boundaries(dataSetRegions(dimId) + 1) - reducedQueryVector(dimId))^2;
        upperBound = upperBound + (boundaries(dataSetRegions(dimId) + 2) - reducedQueryVector(dimId))^2;
    end
end

lowerBound = sqrt(lowerBound);
upperBound = sqrt(upperBound);

end
