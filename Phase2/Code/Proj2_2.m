% Reading query from user
prompt = 'Please enter a query file path:';
filePath = input(prompt,'s');
% Reading directory path from user
prompt = 'Please enter a root directory path: ';
datasetDir = input(prompt,'s');
% Reading the number of similar files from user
prompt = 'Please enter the number of similar files: ';
FileCount = input(prompt);

% Reading the choice of user
disp('Select the similarity measure');
disp('Enter a - Ecludean Distance');
disp('Enter b - Dynamic Time Wrapping Distance');
disp('Enter c - Word File Similarity without A Function');
disp('Enter d - Average File Similarity without A Function');
disp('Enter e - Difference File Similarity without A Function');
disp('Enter f - Word File Similarity with A Function');
disp('Enter g - Average File Similarity with A Function');
disp('Enter h - Difference File Similarity with A Function');
SimilarityMeasureChoice = input('Enter the choice of your similarity : ', 's');

connectivityGraphLoc = '';

if(SimilarityMeasureChoice == 'f' || SimilarityMeasureChoice == 'g' || SimilarityMeasureChoice == 'h')
    connectivityGraphLoc = input('Please enter the location of connectivity graph : ', 's');
end

if(SimilarityMeasureChoice == 'c' || SimilarityMeasureChoice == 'f')
    datasetDir = strcat(datasetDir,'/word');
else if(SimilarityMeasureChoice == 'd' || SimilarityMeasureChoice == 'g')
        datasetDir = strcat(datasetDir,'/average');
    else if(SimilarityMeasureChoice == 'e' || SimilarityMeasureChoice == 'h')
            datasetDir = strcat(datasetDir,'/difference');
        end
    end
end
similarFiles = getSimilarSimulationFiles( filePath, datasetDir, FileCount, SimilarityMeasureChoice, connectivityGraphLoc );
disp(similarFiles);