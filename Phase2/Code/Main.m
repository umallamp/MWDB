% Get all the inputs requried for the project
datasetDir = input('Enter the directory of datasets : ','s');

disp('Select the similarity measure');
disp('Enter a - Ecludean Distance');
disp('Enter b - Dynamic Time Wrapping Distance');
disp('Enter c - Word File Similarity without A Function');
disp('Enter d - Average File Similarity without A Function');
disp('Enter e - Difference File Similarity without A Function');
disp('Enter f - Word File Similarity with A Function');
disp('Enter g - Average File Similarity with A Function');
disp('Enter h - Difference File Similarity with A Function');

% Fast map task a
similarityMeasureChoice = input('Enter the choice of your similarity : ', 's');
reducedDimensions = input('Enter the number of dimensions to reduce : ');
[ mappingError, reducedObjectSpace, pivotArray, distanceInOriginalSpace, distanceInReducedSpace ] = getFastMapReducedSpace( datasetDir, similarityMeasureChoice, reducedDimensions );
disp(strcat('Mapping Error is : ', num2str(mappingError)));

% Fast Map task b
while true
    queryPath = input('Enter the path of query file : ','s');
    reducedDimensions = input('Enter the number of dimensions to reduce : ');
    similarFileRequired = input('Enter the number of similar files required : ');
    [ similarFiles, similarityScores, reducedQuerySpace ] = getFastMapSimilarSimulations( queryPath, reducedDimensions, similarFileRequired, reducedObjectSpace, pivotArray, datasetDir, distanceInOriginalSpace, similarityMeasureChoice  );
    [row,~] = size(similarFiles);
    for index = 1 : row
        disp(strcat(num2str(similarFiles(index, 1)), '->', num2str(similarFiles(index, 2)), '.csv'));
    end
end