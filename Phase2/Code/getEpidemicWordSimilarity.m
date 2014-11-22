function [ similarity ] = getEpidemicWordSimilarity( FirstFilePath, SecondFilePath )
% Delimeter and header lines for input files
delimiterIn = ',';
headerlinesIn = 0;

% Extract data from the input files
firstFileData = importdata(FirstFilePath, delimiterIn, headerlinesIn);
secondFileData = importdata(SecondFilePath, delimiterIn, headerlinesIn);

[~, colCount] = size(firstFileData);

% Get unique rows in both the files
uniqueFirstFileWords = unique(firstFileData(:,4:colCount), 'rows');
uniqueSecondFileWords = unique(secondFileData(:,4:colCount), 'rows');

commonWords = intersect(uniqueFirstFileWords, uniqueSecondFileWords, 'rows');
[similarity, ~] = size(commonWords);

end

