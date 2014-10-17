function [ FirstPivotObject, SecondPivotObject ] = getPivotObjects( distanceMatrix, reducedDistanceMatrix )
% If there are more than one object with the same min similarity we get the
% first object with the minimum similarity.

% Get the dimensions of distance matrix
[row, col] = size(distanceMatrix);

% Get a random pivot
randomPivot = randi([1 row],1,1);

distanceFromFirstPivot = zeros(1, col);
distanceFromSecondPivot = zeros(1, col);

% Obtain the distances from first pivot object
for i = 1 : col
    distanceFromFirstPivot(i) = sqrt((distanceMatrix(randomPivot, i)^2) - ((reducedDistanceMatrix(randomPivot) - reducedDistanceMatrix(i))^2));
end

% Obtain first pivot object
[~, FirstPivotObject] = max(distanceFromFirstPivot);

% Obtain the distances from second pivot object
for i = 1 : col
    distanceFromSecondPivot(i) = sqrt((distanceMatrix(FirstPivotObject, i)^2) - ((reducedDistanceMatrix(FirstPivotObject) - reducedDistanceMatrix(i))^2));
end

% Obtain the second pivot object
[~, SecondPivotObject] = max(distanceMatrix(FirstPivotObject, :));

end

