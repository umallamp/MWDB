function [ entireWords, uniqueWords, dataMatrix ] = getDataMatrix( datasetDir )

% required fileds
delimiterIn = ',';
headerlinesIn = 0;
colStart = 4;
directoryFiles = dir(strcat(datasetDir,'/*.csv'));
entireWords = [];
fileFeatureCount = [];

count = 0;

for fileId = 1 : length(directoryFiles)
    
    % obtain required fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    
    % read the contents of the file
    fileData = importdata(filePath, delimiterIn, headerlinesIn);
    [~, colCount] = size(fileData);
    
    colIndexVector = [2 colStart : colCount];
    
    % get all the words among the files
    fileUniqueWords = unique(fileData(:, colIndexVector), 'rows');
    [rSize, cSize] = size(fileUniqueWords);
    
    % fileFeatureCount is a matrix with the structure as
    % 1. fileId
    % 2. count of the words in the file
    % 3 : cSize feature values of the word
    for index = 1 : rSize
        count = count + 1;
        fileFeatureCount(count, 1) = fileId;
        fileFeatureCount(count, 2) = sum(ismember(fileData(:, colIndexVector), fileUniqueWords(index, :),'rows'));
        fileFeatureCount(count, 3 : cSize + 2) = fileUniqueWords(index, :);
    end
    
    % create the entire words
    entireWords = [entireWords; unique(fileData(:, colIndexVector), 'rows')];
end

% get the unique words among all the files
uniqueWords = unique(entireWords, 'rows');

% define data matrix
dataMatrix = zeros(length(directoryFiles), length(uniqueWords));

[row, col] = size(fileFeatureCount);

% iterate over the fileFeatureCounts
for index = 1 : row
    % find the unique words positions
    foundPositions = ismember(uniqueWords, fileFeatureCount(index, 3 : col), 'rows');
    foundIndex = find(foundPositions, 1);
    
    % if the word is present in at least one wor
    if(~isempty(foundIndex))
        dataMatrix(fileFeatureCount(index, 1), foundIndex) =  fileFeatureCount(index, 2);
    end
end
