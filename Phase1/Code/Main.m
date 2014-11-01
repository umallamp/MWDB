% Get all the inputs requried for the project
dir = input('Enter the directory of datasets : ','s');
w = input('Enter the window length : ');
h = input('Enter the shift length : ');
r = input('Enter the resolution : ');

% Task 1
disp('Task 1 - Epidemic word file generation started - wait for completion message');
generateEpidemicWordFile(dir, w, h, r);
disp(strcat('Task 1 - Epidemic word file generation completed - files are placed at ', dir, '/word'));

% Inputs requried for Task 2
graphdir = input('Enter the director of connectivity graph : ', 's');
alpha = input('Enter the value of alpha : ');

% Task 2
disp('Task 2 - Epidemic avg and diff file generation started - wait for completion message');
[connectivityGraph, ~, ~ ] = generateAvgAndDiffWordFiles(graphdir, dir, alpha);
disp(strcat('Task 2 - Epidemic avg and diff files are genereate at ', dir, '/average', ',', dir, '/difference respectively'));

[sRow, ~] = size(connectivityGraph.textdata);
stateIndexes = connectivityGraph.textdata(2 : sRow);

% connectivityGraph = importdata('/home/sampath/Sampath/multimedia-and-web-databases-epidemic-datasets/ProjectDocuments/Phase1/LocationMatrix.csv', ',', 1);
% w = 10
% choice = 3
% visualizationFile = 37

% Task 3
while true
    visualizationFile = input('Enter the file number to visualize window strengths : ');
    disp('Enter 1 - the two windows, corresponding to f , with the highest and lowest strengths in the file epidemic word file');
    disp('Enter 2 - the two windows, corresponding to f , with the highest and lowest strengths in the file epidemic word file avg');
    disp('Enter 3 - the two windows, corresponding to f , with the highest and lowest strengths in the file epidemic word file diff');
    choice = input('Enter your choice : ');
    if(choice == 1)
        originalFile = importdata(strcat(dir,'/',num2str(visualizationFile),'.csv'),',');
        wordFile = importdata(strcat(dir,'/word/', num2str(visualizationFile), '.csv'), ',');
        generateHeatMap(originalFile.data, wordFile, w, connectivityGraph, stateIndexes);
    else
        if(choice == 2)
            originalFile = importdata(strcat(dir,'/',num2str(visualizationFile),'.csv'),',');
            avgWordFile = importdata(strcat(dir,'/average/', num2str(visualizationFile), '.csv'), ',');
            generateHeatMap(originalFile.data, avgWordFile, w, connectivityGraph, stateIndexes);
        else
            originalFile = importdata(strcat(dir,'/',num2str(visualizationFile),'.csv'),',');
            diffWordFile = importdata(strcat(dir,'/difference/', num2str(visualizationFile), '.csv'), ',');
            generateHeatMap(originalFile.data, diffWordFile, w, connectivityGraph, stateIndexes);
        end
    end
end