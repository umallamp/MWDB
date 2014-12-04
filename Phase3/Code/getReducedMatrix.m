function [ reducedDataMatrix, reCreateMatrix ] = getReducedMatrix( dataMatrix )

% Variance to preserve
variance = 99;

% dimensionality reduction
[u, s, v] = svd(dataMatrix);
eigenValues = diag(s);
eigenCSum = cumsum(eigenValues);
eigenImportance = (eigenCSum / eigenCSum(length(eigenCSum))) * 100;
inherantDims = find(eigenImportance <= variance, 1, 'last');
reducedDataMatrix = u(:, 1:inherantDims) * s(1 : inherantDims, 1 : inherantDims);
reCreateMatrix = v(:, 1 : inherantDims);

end

