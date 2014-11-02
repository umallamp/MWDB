function [ similarFiles, similarityScores, reducedQuerySpace ] = getFastMapSimilarSimulations( newSimulationFilePath, reducedDimensions, similarFileRequired, reducedObjectSpace, pivotArray, datasetDir, distanceMatrix, similarityMeasureChoice  )

% Get metadata about the files
[~, ~, ext] = fileparts(newSimulationFilePath);

% Matrix for representation of query in reduced space
reducedQuerySpace = zeros(1, reducedDimensions);
columnId = 0;
getQueryInReducedSpace(reducedDimensions);

% Get the most similar files to the query object
[similarFiles, similarityScores] = findMostSimilarObjectsToQuery(reducedObjectSpace, reducedQuerySpace, similarFileRequired);

% Function to map query to reduced space
    function getQueryInReducedSpace(reducedDimensions)
        % If the query is represented in all dimensions then return
        if(reducedDimensions <= 0)
            return;
        else
            columnId = columnId + 1;
        end
        
        % Obtain the pivot objects from pivot array
        firstPivot = pivotArray(1, columnId);
        secondPivot = pivotArray(2, columnId);
        
        % Obtain path for the pivot objects
        firstPivotObject = strcat(datasetDir, '/', num2str(firstPivot), ext);
        secondPivotObject = strcat(datasetDir, '/', num2str(secondPivot), ext);
        
        % Obtain the distances of query from first pivot object and
        % second pivot object
        distanceFromFirstPivot = getDistanceFromSimilarity(getChoiceSimulationSimilarity(firstPivotObject, newSimulationFilePath, similarityMeasureChoice));
        distanceFromSecondPivot = getDistanceFromSimilarity(getChoiceSimulationSimilarity(secondPivotObject, newSimulationFilePath, similarityMeasureChoice));
        
        % Obtain the representation of query in the new dimension
        pointInNewDimension = (distanceFromFirstPivot^2 + distanceMatrix(firstPivot, secondPivot)^2 - distanceFromSecondPivot^2) / (2*distanceMatrix(firstPivot, secondPivot));
        reducedQuerySpace(columnId) = pointInNewDimension;
        
        % Recurssively call the function for all the dimension
        getQueryInReducedSpace(reducedDimensions - 1);
    end
end

function [similarFiles, similarityScores] = findMostSimilarObjectsToQuery(reducedObjectSpace, reducedQuerySpace, similarFileRequired)

% define the variables required fro computation
[row, ~] = size(reducedObjectSpace);
similarityScores = zeros(row, 2);

% Compute the distance between object and query
for i = 1: row
    similarityScores(i, 2) = i;
    similarityScores(i, 1) = sqrt(sum((reducedObjectSpace(i, :) - reducedQuerySpace).^2));
end

% Sort the similarites in descending order and obtain the files that are
% most similar.
sortedScores = sortrows(similarityScores);
similarFiles = sortedScores(1 : similarFileRequired, :);

end
