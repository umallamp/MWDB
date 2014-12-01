function [ neighbours, vectorsExpanded ] = getNearestNeighbours( queryWordFile, neighbourCount, totalFileCount, features, colIndexVector, reducedFeatures, minValues, maxValues, bitsPerDims, boundaries, dataSetRegions, reducedDataMatrix )

% represents query as vector by counting the number of unique words
queryVector = zeros(1, length(features));

% get query vector
for featureId = 1 : length(features)
    queryVector(featureId) = sum(ismember(queryWordFile(:, colIndexVector), features(featureId, :),'rows'));
end

queryVector = queryVector / norm(queryVector);

% get reduced query vector and regions for dimensions
% reducedQueryVector = queryVector * reducedFeatures';
reducedQueryVector = queryVector;
queryRegions = getRegions(reducedQueryVector, minValues, maxValues, bitsPerDims);

% initialize variables for query processing
neighbours = zeros(neighbourCount, 2);
neighbours(:, 2) = Inf(neighbourCount, 1);

% lowerBounds = zeros(neighbourCount);
% upperBounds = zeros(neighbourCount);

distance = Inf;
vectorsExpanded = 0;
for fileId = 1 : totalFileCount
    [lowerBound, ~] = getBounds(reducedQueryVector, queryRegions, boundaries, dataSetRegions(fileId, :));
    if(lowerBound < distance)
        vectorsExpanded = vectorsExpanded + 1;
        [distance, neighbours] = insertCandidate(norm(reducedDataMatrix(fileId, :) - reducedQueryVector), fileId, neighbourCount, neighbours);
    end
end
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
