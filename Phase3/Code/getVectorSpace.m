function [ dataMatrix ] = getVectorSpace( datasetDir )

delimiterIn = ',';
headerlinesIn = 0;
colStart = 4;
directoryFiles = dir(strcat(datasetDir,'/*.csv'));

[fileCount, ~] = size(directoryFiles);
fileCount = 10;

% define hash map to store unique words in each word file
dataSetUniqueVectors = containers.Map();

% Constructing a HashMap to hold all the unique values
for index = 1 : fileCount
    % get the file path
    fileName = strcat(datasetDir, '/', (directoryFiles(index).name));
    dataForFile = importdata(fileName, delimiterIn, headerlinesIn);
    
    [rSize, cSize] = size(dataForFile);
    
    for i = 1 : rSize
        % convert the word to string
        wordVector = mat2str(dataForFile(i, colStart : cSize));
        
        % insert the word into the hashmap
        if(~isKey(dataSetUniqueVectors, wordVector))
            dataSetUniqueVectors(wordVector) = 1;
        end
    end
    
    disp(index);
    
end

% get all the unique words from hashmap
uniqueVectors = dataSetUniqueVectors.keys;
[~ , totalUniqueVectors] = size(uniqueVectors);

% matrix to store vectors
dataMatrix = zeros (fileCount, totalUniqueVectors);

for index = 1 : fileCount
    % map for every file
    fileVector = containers.Map();
    fileName = strcat(datasetDir, '/', (directoryFiles(index).name));
    [~, fName, ~] = fileparts(directoryFiles(index).name); 
    
    dataForFile = importdata(fileName, delimiterIn, headerlinesIn);
    [~, cSize] = size(dataForFile);
    
    % get the unique words in the file
    requiredFileData = dataForFile(:, colStart : cSize);
    uniqueFileVectors = unique(requiredFileData, 'rows');
    [uniqueCount, ~] = size(uniqueFileVectors);
    
    for i = 1 : uniqueCount
        % convert word to string
        wordVector = mat2str(uniqueFileVectors(i,:));
        
        % if the word is not present in the map intialize to 1
        if(~isKey(fileVector, wordVector))
            fileVector(wordVector) = 1;
        % if the word is present in the map add 1
        else
            fileVector(wordVector) = fileVector(wordVector) + 1;
        end
    end
    
    % construct the vector for the file
    for i = 1 : totalUniqueVectors
        % if the the file has the feature
        if(isKey(fileVector, uniqueVectors(i)))
            dataMatrix(str2double(fName), i) = fileVector(uniqueVectors(i));
        end
    end
end
