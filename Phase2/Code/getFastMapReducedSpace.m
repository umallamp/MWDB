function [ mappingError, reducedObjectSpace, pivotArray, distanceInOriginalSpace, distanceInReducedSpace ] = getFastMapReducedSpace( datasetDir, similarityMeasureChoice, reducedDimensions, connectivityGraphLoc )

% Read all the csv files in the given directory
directoryFiles = dir(strcat(datasetDir,'/*.csv'));
arrUniqueWords = [];
idfArray = [];

if(similarityMeasureChoice == 'f' || similarityMeasureChoice == 'g' || similarityMeasureChoice == 'h')
    [arrUniqueWords, idfArray] = getTermIDF(datasetDir);
end

% Get the distances between objects in original space
distanceInOriginalSpace = getOriginalDistanceMatrix(datasetDir, directoryFiles, similarityMeasureChoice, connectivityGraphLoc, arrUniqueWords, idfArray);
distanceInReducedSpace = zeros(size(distanceInOriginalSpace));

% Global varibles used by fast map function
reducedObjectSpace = zeros(length(directoryFiles), reducedDimensions);
pivotArray = zeros(2, reducedDimensions);

% ColumnId represents the current dimension calculated in fast map
columnId = 0;

fastMap(reducedDimensions, distanceInOriginalSpace);
distanceInReducedSpace = getDistanceMatrixInReducedSpace(reducedObjectSpace, distanceInReducedSpace);
mappingError = getMappingError(distanceInOriginalSpace, distanceInReducedSpace);

% Fast map function
    function fastMap(reducedDimensions, distanceMatrix)
        % If the distance matrix is computed in reduced dimensions then
        % exit else compute the distance in current dimension
        if(reducedDimensions <= 0)
            return;
        else
            columnId = columnId + 1;
        end
        
        [row, ~] = size(distanceMatrix);
        
        % Objtain the pivot objects
        if(columnId == 1)
            [ FirstPivotObject, SecondPivotObject ] = getPivotObjects(distanceMatrix, zeros(row, 1));
        else
            [ FirstPivotObject, SecondPivotObject ] = getPivotObjects(distanceMatrix, reducedObjectSpace(:, columnId - 1));
        end
        
        % Record the pivot object ids
        pivotArray(1, columnId) = FirstPivotObject;
        pivotArray(2, columnId) = SecondPivotObject;
        
        % If the distance between the pivot points is 0 then the objects
        % are completely similar
        if(distanceMatrix(FirstPivotObject, SecondPivotObject) == 0)
            reducedObjectSpace(:, columnId) = 0;
            return;
        end
        
        [row, ~] = size(distanceMatrix);
        
        % Compute the projection of points on the line formed by the two
        % points
        for fileId = 1 : row
            % Compute the new point in reduced space
            newPoint = (distanceMatrix(FirstPivotObject, fileId)^2 + distanceMatrix(FirstPivotObject, SecondPivotObject)^2 - distanceMatrix(SecondPivotObject, fileId)^2) / (2*distanceMatrix(FirstPivotObject, SecondPivotObject));
            reducedObjectSpace(fileId, columnId) = newPoint;
        end
        
        %Recurssively call the fast map function
        fastMap(reducedDimensions - 1, distanceMatrix);
    end
end

function [ originalDistanceMatrix ] = getOriginalDistanceMatrix(datasetDir, directoryFiles, similarityMeasureChoice, connectivityGraphLoc, arrUniqueWords, idfArray)
% Get the number of files in the directory
fileCount = length(directoryFiles);

% Initialize the original distance matrix
originalDistanceMatrix = zeros(fileCount, fileCount);

% Compute the object object distance matrix in original space
for i = 1 : length(directoryFiles)
    % obtain meta data infromation fileds from data file
    [~, firstfname, ext] = fileparts(directoryFiles(i, 1).name);
    firstFilePath = strcat(datasetDir, '/', firstfname, ext);
    
    for j = i : length(directoryFiles)
        % obtain meta data infromation fileds from data file
        [~, secondfname, ext] = fileparts(directoryFiles(j, 1).name);
        secondFilePath = strcat(datasetDir, '/', secondfname, ext);
        
        % Compute similarity between the first file and second file and
        % assign to both the indices becuase of commutative properity
        originalDistanceMatrix(str2double(firstfname), str2double(secondfname)) = getDistanceFromSimilarity(getChoiceSimulationSimilarity(firstFilePath, secondFilePath, similarityMeasureChoice, connectivityGraphLoc, arrUniqueWords, idfArray), similarityMeasureChoice);
        originalDistanceMatrix(str2double(secondfname), str2double(firstfname)) = originalDistanceMatrix(str2double(firstfname), str2double(secondfname));
    end
end
% distanceMatrix = (originalDistanceMatrix - min(originalDistanceMatrix(:))) / (max(originalDistanceMatrix(:)) - min(originalDistanceMatrix(:)));
% originalDistanceMatrix = distanceMatrix;
end

function [distanceInReducedSpace] = getDistanceMatrixInReducedSpace(reducedObjectSpace, distanceInReducedSpace)
% Get the size of reduced object space
[row, ~] = size(reducedObjectSpace);

% Get the distances in reduced space
for i = 1 : row
    for j = i : row
        distanceInReducedSpace(i,j) = sqrt(sum((reducedObjectSpace(i, :) - reducedObjectSpace(j,:)).^2));
        distanceInReducedSpace(j,i) = distanceInReducedSpace(i,j);
    end
end
end

% Function to get the mapping error
function [ mappingError ] = getMappingError(distanceInOriginalSpace, distanceInReducedSpace)
[originalRows, ~] = size(distanceInOriginalSpace);
[reducedRows, ~] = size(distanceInReducedSpace);
mappingError = 0;

% Mapping Error computation
for i = 1 : originalRows
    for j = 1 : reducedRows
        if(distanceInOriginalSpace(i,j) ~= 0)
            mappingError = mappingError + ((distanceInOriginalSpace(i,j) - distanceInReducedSpace(i,j)) / distanceInOriginalSpace(i,j));
        end
    end
end
end
