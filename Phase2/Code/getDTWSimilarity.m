function [ avgSimilarity ] = getDTWSimilarity( FirstFilePath, SecondFilePath )
tic
% Delimeter and header lines for input files
delimiterIn = ',';
headerlinesIn = 1;

% Extract data from the input files
firstFileData = importdata(FirstFilePath, delimiterIn, headerlinesIn);
secondFileData = importdata(SecondFilePath,delimiterIn, headerlinesIn);

% Get the size of the files
[~, colCount] = size(firstFileData.data);

% Get the sum of DTW Distance for all the states
similarity = 0;
for i = 1 : colCount
    similarity = similarity + getDTWDistance(firstFileData.data(:,i), secondFileData.data(:,i));
end

% Get average similarity
avgSimilarity = 1 / (1 + (similarity / colCount));

toc
end

