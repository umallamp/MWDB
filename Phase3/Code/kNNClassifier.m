function [ testLabels ] = kNNClassifier( datasetDir, classLabelsPath, k )

% required fields
delimiterIn = ',';
headerlinesIn = 1;

% get the data matrix
[~, ~, dataMatrix, ~] = getDataMatrix(datasetDir);

% get normalized matrix by computing L2 norm
dataMatrix = getNormalizedMatrix(dataMatrix);

% Perform SVD dimensionality reduction to preserver 99% importance between
% objects
[ reducedDataMatrix, ~ ] = getReducedMatrix( dataMatrix );

[rowCount, ~] = size(reducedDataMatrix);

% read the class lables
classLabelsStruct = importdata(classLabelsPath, delimiterIn, headerlinesIn);

fileNames = classLabelsStruct.textdata;
labels = classLabelsStruct.data;

% array to store the class lables
classLabels = zeros(length(labels), 2);

% create a data structure for fileId, classLabel
for index = 1 : length(labels)
    fileName = char(fileNames(index + 1));
    [~, fileId, ~] = fileparts(fileName);
    classLabels(index, :) = [str2double(fileId) labels(index)];
end

testLabels = [];
count = 0;
for fileId = 1 : rowCount
    distancesWithLabels = zeros(length(labels), 2);
    % calculate distances only for unlabled objects
    if(isempty(find(classLabels(:,1) == fileId, 1)))
        % calculate the distances between unlabled and all labled
        for labelId = 1 : length(labels)
            distancesWithLabels(labelId, 1) = classLabels(labelId, 2);
            distancesWithLabels(labelId, 2) = getDistance(reducedDataMatrix(fileId, :), reducedDataMatrix(classLabels(labelId), :));
        end
        
        % order based on distances
        [~, order] = sort(distancesWithLabels(:, 2));
        sortedDistances = distancesWithLabels(order, :);
        kNearestNeighbours = sortedDistances(1 : k, :);
        
        % find the unique class labels among the nearest neighbours
        neighbourLabels = kNearestNeighbours(:, 1);
        [~, indices] = unique(neighbourLabels);
        uniqueLabels = neighbourLabels(sort(indices));
        
        % find the frequency of class labels
        uniqueLabelsCount = zeros(length(uniqueLabels), 1);
        for index = 1 : length(uniqueLabels)
            uniqueLabelsCount(index) = length(find(neighbourLabels == uniqueLabels(index)));
        end
        
        % find the class lable with highest frequency and assign to the
        % file
        [~, maxIndex] = max(uniqueLabelsCount);
        testLabels = [testLabels; [fileId uniqueLabels(maxIndex)]];
    end
end
end


