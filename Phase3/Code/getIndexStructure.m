function [ wordFileVectors, bitsPerDims ] = getIndexStructure( bitsPerVector, wordfilePath )

delimiterIn = ',';
metaDataCols = 3;
directoryFiles = dir(strcat(wordfilePath, '/*.csv'));
totalFiles = length(directoryFiles);

% extract all meta data information from sample file
sampleFile = importdata(strcat(wordfilePath, '/', directoryFiles(1, 1).name), delimiterIn);
[rowCount, colCount] = size(sampleFile);

% 3 dimensional array to store the values of word files
wordFileVectors = zeros(rowCount,colCount, totalFiles);

% arrays to store min max values occured in the dimensions
minValues = Inf(1, colCount - metaDataCols);
maxValues = -1 * Inf(1, colCount - metaDataCols);

% process each word file and find the min and max boundaries for each
% vector
for fileId = 1 : length(directoryFiles)
    
    % read the file from the directory
    [~, fname, ~] = fileparts(directoryFiles(fileId, 1).name);
    epidemicWordFile = importdata(strcat(wordfilePath, '/', directoryFiles(fileId, 1).name), delimiterIn);
    
    % get min and max values for each dimension in the current file
    minValue = min(epidemicWordFile(:, metaDataCols + 1 : colCount));
    maxValue = max(epidemicWordFile(:, metaDataCols + 1 : colCount));
    
    % update min and max values for all the files
    minValues = min(minValues, minValue);
    maxValues = max(maxValues, maxValue);
    
    % add wordfile data to three dimensional matrix
    wordFileVectors(:, :, str2double(fname)) = epidemicWordFile;
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

