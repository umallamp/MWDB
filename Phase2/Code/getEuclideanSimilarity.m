function [ similarity ] = getEuclideanSimilarity( FirstFilePath, SecondFilePath )
% Delimeter and header lines for input files
delimiterIn = ',';
headerlinesIn = 1;

% Extract data from the input files
firstFileData = importdata(FirstFilePath, delimiterIn, headerlinesIn);
secondFileData = importdata(SecondFilePath,delimiterIn, headerlinesIn);

% Get the size of the files
[~, colCount] = size(firstFileData.data);


% obtain the eculedian distances for all the states
eucledianDistance = sum(sqrt(sum((firstFileData.data - secondFileData.data).^2)));

% obtain the similarity value
similarity = 1 / (1 + (eucledianDistance / colCount));

end

