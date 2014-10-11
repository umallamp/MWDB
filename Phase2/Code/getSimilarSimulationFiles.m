function [ similarFiles ] = getSimilarSimulationFiles( newSimFilePath, datasetDir, FileCount, Choice )

% Required variables for the program
directoryFiles = dir(strcat(datasetDir,'/*.csv'));

% Initialize the similarity scores to zero and the arry to store file names
% processed
similarityScores = zeros(length(directoryFiles));
fNames = zeros(length(directoryFiles));

for fileId = 1 : length(directoryFiles)
    
    % obtain required fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    fNames(fileId) = str2double(fname);
    % Get the similarity score based on the user choice
    switch Choice
        % Eculedian Distance
        case 'a'
            similarityScores(fileId) = getEuclideanSimilarity(newSimFilePath, filePath);
            % Dynamic Tme Wrapping Distance
        case 'b'
            similarityScores(fileId) = getDTWSimilarity(newSimFilePath, filePath);
            % Word File Distance
        case 'c'
            similarityScores(fileId) = getEpidemicWordSimilarity(newSimFilePath, filePath);
            % Average File Distance
        case 'd'
            similarityScores(fileId) = getEpidemicWordSimilarity(newSimFilePath, filePath);
            % Difference File Distance
        case 'e'
            similarityScores(fileId) = getEpidemicWordSimilarity(newSimFilePath, filePath);
    end
end

% Finding file names with maxiumum similarity scor
sortedScores = sort(similarityScores, 'descend');
maxIndexes = similarityScores > sortedScores(FileCount + 1);
similarFiles = fNames(maxIndexes);

end

