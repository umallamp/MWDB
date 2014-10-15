function [ FirstPivotObject, SecondPivotObject ] = chooseDistantObjects( datasetDir, similarityMeasureChoice )

% Read all the csv files in the given directory
directoryFiles = dir(strcat(datasetDir,'/*.csv'));

% Randomly choose the second pivot object
fileCount = length(directoryFiles);
randomPivot = randi([1 fileCount],1,1);
[~, fname, ext] = fileparts(directoryFiles(randomPivot, 1).name);
randomPivotObject = strcat(datasetDir, '/', fname, ext);

% Initialize the similarity scores to zero
similarityScores = zeros(length(directoryFiles), 1);

for fileId = 1 : length(directoryFiles)
    % obtain meta data infromation fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    
    % Compute similarity between the random pivot and all the other files
    if(~strcmp(filePath, randomPivotObject))
        similarityScores(fileId) = getChoiceSimulationSimilarity(randomPivotObject, filePath, similarityMeasureChoice);
    end
end

% Get the first pivot object
[~, fileIndex] = min(similarityScores);
[~, fname, ext] = fileparts(directoryFiles(fileIndex, 1).name);
FirstPivotObject = strcat(datasetDir, '/', fname, ext);

% Reset the similarity scores to zero
similarityScores = zeros(length(directoryFiles), 1);

for fileId = 1 : length(directoryFiles)
    % obtain meta data infromation fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    
    % Compute similarity between the random pivot and all the other files
    similarityScores(fileId) = getChoiceSimulationSimilarity(FirstPivotObject, filePath, similarityMeasureChoice);
end

% Get the second pivot object
[~, fileIndex] = min(similarityScores);
[~, fname, ext] = fileparts(directoryFiles(fileIndex, 1).name);
SecondPivotObject = strcat(datasetDir, '/', fname, ext);
