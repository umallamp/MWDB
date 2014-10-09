function [ similarity ] = getEuclideanSimilarity( FirstFilePath, SecondFilePath )
% Delimeter and header lines for input files
delimiterIn = ',';
headerlinesIn = 1;

% Extract data from the input files
firstFileData = importdata(FirstFilePath, delimiterIn, headerlinesIn);
secondFileData = importdata(SecondFilePath,delimiterIn, headerlinesIn);

% Get the size of the files
[rowCount, colCount] = size(firstFileData.data);


% obtain the eculedian distances for all the states
eucledianDistance = 0;
for index = 1 : colCount
    eucledianDistance = eucledianDistance + sqrt(sum((firstFileData.data(:,index) - secondFileData.data(:,index)).^2));
end

% obtain the similarity value
similarity = 1 / (1 + (eucledianDistance / rowCount));

end

