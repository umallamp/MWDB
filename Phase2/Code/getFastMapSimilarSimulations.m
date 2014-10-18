function [ similarFiles ] = getFastMapSimilarSimulations( newSimulationFilePath, reducedDimensions, similarFileRequired, reducedObjectSpace, pivotArray, datasetDir, distanceMatrix, similarityMeasureChoice  )

% Get metadata about the files
[~, ~, ext] = fileparts(newSimulationFilePath);

% Matrix for representation of query in reduced space
reducedQuerySpace = zeros(1, reducedDimensions);
columnId = 0;
getQueryInReducedSpace(reducedDimensions);

% Get the most similar files to the query object
similarFiles = findMostSimilarObjectsToQuery(reducedObjectSpace, reducedQuerySpace, similarFileRequired);

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
        
        % If the computation is fro the first dimension
        if(columnId == 1)
            % Obtain the distances of query from first pivot object and
            % second pivot object
            distanceFromFirstPivot = getDistanceFromSimilarity(getChoiceSimulationSimilarity(firstPivotObject, newSimulationFilePath, similarityMeasureChoice));
            distanceFromSecondPivot = getDistanceFromSimilarity(getChoiceSimulationSimilarity(secondPivotObject, newSimulationFilePath, similarityMeasureChoice));
            
            % Obtain the representation of query in the new dimension
            pointInNewDimension = (distanceFromFirstPivot^2 + distanceMatrix(firstPivot, secondPivot)^2 - distanceFromSecondPivot^2) / (2*distanceMatrix(firstPivot, secondPivot));
            reducedQuerySpace(columnId) = pointInNewDimension;
        else
            % Objtain the distances of pivot objects on the hyperplane
            % after projecting pivot object on the hyper plane
            distanceFromFirstPivot = sqrt((getDistanceFromSimilarity(getChoiceSimulationSimilarity(firstPivotObject, newSimulationFilePath, similarityMeasureChoice))^2) - (reducedObjectSpace(firstPivot,columnId-1) - reducedQuerySpace(1,columnId-1))^2);
            distanceFromSecondPivot = sqrt((getDistanceFromSimilarity(getChoiceSimulationSimilarity(secondPivotObject, newSimulationFilePath, similarityMeasureChoice))^2) - (reducedObjectSpace(secondPivot,columnId-1) - reducedQuerySpace(1,columnId-1))^2);
            distanceBetweenPivotObjects = sqrt((distanceMatrix(firstPivot, secondPivot)^2) - (reducedObjectSpace(firstPivot, columnId) - reducedObjectSpace(secondPivot, columnId-1))^2);
            
            % Obtain the point on the new dimension
            reducedQuerySpace(columnId) = (distanceFromFirstPivot^2 + distanceBetweenPivotObjects^2 - distanceFromSecondPivot^2) / (2*distanceBetweenPivotObjects);
        end
        
        % Recurssively call the function for all the dimension
        getQueryInReducedSpace(reducedDimensions - 1);
    end
end

function [similarFiles] = findMostSimilarObjectsToQuery(reducedObjectSpace, reducedQuerySpace, similarFileRequired)

% define the variables required fro computation
[row, ~] = size(reducedObjectSpace);
similarityScores = zeros(1, row);
fNames = zeros(1, row);
% Compute the distance between object and query
for i = 1: row
    fNames(i) = i;
    similarityScores(i) = sqrt(sum((reducedObjectSpace(i, :) - reducedQuerySpace).^2));
end

% Sort the similarites in descending order and obtain the files that are
% most similar.
sortedScores = sort(similarityScores, 'descend');
maxIndexes = similarityScores > sortedScores(similarFileRequired + 1);
similarFiles = fNames(maxIndexes);

end
