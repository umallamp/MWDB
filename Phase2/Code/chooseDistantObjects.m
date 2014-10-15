function [ FirstPivotObject, SecondPivotObject ] = chooseDistantObjects( datasetDir, similarityMeasureChoice )

% Read all the csv files in the given directory
directoryFiles = dir(strcat(datasetDir,'/*.csv'));

% Randomly choose the second pivot object
fileCount = length(directoryFiles);
randomPivot = randi([1 fileCount],1,1);
[~, fname, ext] = fileparts(directoryFiles(randomPivot, 1).name);
randomPivotObject = strcat(datasetDir, '/', fname, ext);

% Initialize the similarity score to highest value
minSimilarity = 1;

for fileId = 1 : length(directoryFiles)
    % obtain meta data infromation fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    
    % Compute similarity between the random pivot and all the other files
    % to get first pivot file
    similarity = getChoiceSimulationSimilarity(randomPivotObject, filePath, similarityMeasureChoice);
    if(similarity < minSimilarity)
        minSimilarity = similarity;
        FirstPivotObject = filePath;
    end
    
end

% Reset the similarity score to highest value
minSimilarity = 1;

for fileId = 1 : length(directoryFiles)
    % obtain meta data infromation fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    
    % Compute similarity between the first pivot and all the other files to
    % get second pivot
    similarity = getChoiceSimulationSimilarity(FirstPivotObject, filePath, similarityMeasureChoice);
    if(similarity < minSimilarity)
        minSimilarity = similarity;
        SecondPivotObject = filePath;
    end
end