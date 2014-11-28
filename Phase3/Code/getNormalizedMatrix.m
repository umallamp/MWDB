function [ normalized ] = getNormalizedMatrix( unNormalized )

[rowCount, ~] = size(unNormalized);

% construct normalization factor matrix
normFactor = max(unNormalized) - min(unNormalized);
normFactorMatrix = repmat(normFactor, [rowCount 1]);

% construct min values matrix
minValues = min(unNormalized);
minMatrix = repmat(minValues, [rowCount 1]);

% get normalized values
normalized = (unNormalized - minMatrix)./normFactorMatrix;

% replace all nan with 0
normalized(isnan(normalized)) = 0;

end
