function [ wordFileVectors, bitsPerDims ] = getIndexStructure( bitsPerVector, wordfilePath )

delimiterIn = ',';
headerlinesIn = 0;
colStart = 2;
directoryFiles = dir(strcat(datasetDir,'/*.csv'));
entireWords = [];
for fileId = 1 : length(directoryFiles)
    
    % obtain required fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    
    % read the contents of the file
    fileData = importdata(filePath, delimiterIn, headerlinesIn);
    [~, colCount] = size(fileData);
    
    % get all the words among the files
    entireWords = [entireWords; unique(fileData(:, colStart : colCount), 'rows')];
end

% get the unique words among all the files
uniqueWords = unique(entireWords, 'rows');

% data matrix for SVD
dataMatrix = zeros(length(directoryFiles), length(uniqueWords));

% iterate over the number of files in the directory
for fileId = 1 : length(directoryFiles)
    display(strcat('Started processing file : ', num2str(fileId)));
    
    % obtain required fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    
    % read the contents of the file
    fileData = importdata(filePath, delimiterIn, headerlinesIn);
    [~, colCount] = size(fileData);

    % iterate over the unique words
    for wordId = 1 : length(uniqueWords)
        % count the number of instances of unique word in the file
        dataMatrix(fileId, wordId) = sum(ismember(fileData(:, colStart : colCount),uniqueWords(wordId, :),'rows'));
    end
    display(strcat('Finished processing file : ', num2str(fileId)));
end

% array for bits per dimension
bitsPerDims = zeros(1, colCount - metaDataCols);

% compute the number of bits for each dimension
remainder = mod(bitsPerVector, (colCount - metaDataCols));
bitsPerDim = floor(bitsPerVector / (colCount - metaDataCols));

for index = 1 : colCount - metaDataCols
    if(index <= remainder)
        bitsPerDims(index) = bitsPerDim + 1;
    else
        bitsPerDims(index) = bitsPerDim;
    end
end

end

