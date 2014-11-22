function [ similarFiles ] = getSimilarSimulationFiles( newSimFilePath, datasetDir, FileCount, SimilarityMeasureChoice, connectivityGraphLoc )

% Required variables for the program
directoryFiles = dir(strcat(datasetDir,'/*.csv'));
arrUniqueWords = [];
idfArray = [];

% Compute the idf scores for similarity measures f g h
if(SimilarityMeasureChoice == 'f' || SimilarityMeasureChoice == 'g' || SimilarityMeasureChoice == 'h')
    [arrUniqueWords, idfArray] = getTermIDF(datasetDir);
end

% Initialize the similarity scores to zero and the arry to store file names
% processed
similarityScores = zeros(length(directoryFiles), 2);

for fileId = 1 : length(directoryFiles)
    
    % obtain required fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filePath = strcat(datasetDir, '/', fname, ext);
    similarityScores(fileId, 2) = str2double(fname);
    
    % Get the similarity score based on the user choice
    similarityScores(fileId, 1) = getChoiceSimulationSimilarity(newSimFilePath, filePath, SimilarityMeasureChoice, connectivityGraphLoc, arrUniqueWords, idfArray);
end

% Finding file names with maxiumum similarity scor
sortedScores = sortrows(similarityScores, -1);
similarFiles = sortedScores(1 : FileCount, :);

if(SimilarityMeasureChoice == 'a' || SimilarityMeasureChoice == 'b')
    isSimulationFile = true;
else
    isSimulationFile = false;
end

visualizeHeatMaps(datasetDir, newSimFilePath, similarFiles, isSimulationFile);

end

