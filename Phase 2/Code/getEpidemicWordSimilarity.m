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

% Get the size of the files
[fRowCount, ~] = size(uniqueFirstFileWords);
[sRowCount, ~] = size(uniqueSecondFileWords);

% Get the similarity between two files
similarity = 0;
for i = 1 : fRowCount
    for j = 1 : sRowCount
        if(all(uniqueFirstFileWords(i,:) == uniqueSecondFileWords(j,:)))
            similarity = similarity + 1;
            break;
        end
    end
end        
end

