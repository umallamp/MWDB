% Read all the csv files in the given directory
datasetDir = 'C:\Users\pdadi\Desktop\TestExecution\Input';

directoryFiles = dir(strcat(datasetDir,'/*.csv'));
similarityMeasureChoice = 'b';

% Get the number of files in the directory
fileCount = length(directoryFiles);

% Initialize the original distance matrix
originalDistanceMatrix = zeros(fileCount, fileCount);

% Compute the object object distance matrix in original space
for i = 1 : length(directoryFiles)
    % obtain meta data infromation fileds from data file
    [~, firstfname, ext] = fileparts(directoryFiles(i, 1).name);
    firstFilePath = strcat(datasetDir, '/', firstfname, ext);
    
    for j = 1 : length(directoryFiles)
        % obtain meta data infromation fileds from data file
        [~, secondfname, ext] = fileparts(directoryFiles(j, 1).name);
        secondFilePath = strcat(datasetDir, '/', secondfname, ext);
        
        % Compute similarity between the first file and second file and
        % assign to both the indices becuase of commutative properity
        originalDistanceMatrix(str2double(firstfname), str2double(secondfname)) = getChoiceSimulationSimilarity(firstFilePath, secondFilePath, similarityMeasureChoice);
%         originalDistanceMatrix(str2double(secondfname), str2double(firstfname)) = originalDistanceMatrix(str2double(firstfname), str2double(secondfname));
    end
end