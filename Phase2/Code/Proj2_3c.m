% Reading the directory path from user
prompt = 'Please enter the directory for epidemic simulation files:';
directory = input(prompt,'s');
% Reading value of r(number of latent semantics) from user
prompt = 'Please enter a value for number of latent semantics (r) :';
r = input(prompt);

disp('Select the similarity measure');
disp('Enter a - Ecludean Distance');
disp('Enter b - Dynamic Time Wrapping Distance');
disp('Enter c - Word File Similarity without A Function');
disp('Enter d - Average File Similarity without A Function');
disp('Enter e - Difference File Similarity without A Function');
disp('Enter f - Word File Similarity with A Function');
disp('Enter g - Average File Similarity with A Function');
disp('Enter h - Difference File Similarity with A Function');
similarityMeasureChoice = input('Enter the choice of your similarity : ', 's');


tic;
switch similarityMeasureChoice
            % Euclidean
        case 'a'
            directory = directory;
            % Dynamic Tme Wrapping - Simulation file path
        case 'b'
            directory = directory;
            % Word Files path
        case 'c'
            directory = strcat(directory,'/word');
            % Average File path
        case 'd'
            directory = strcat(directory,'/average');
            % Difference File path
        case 'e'
            directory = strcat(directory,'/difference');
            % word file path
        case 'f'
            directory = strcat(directory,'/word');
            % Average File path
        case 'g'
            directory = strcat(directory,'/average');
            % Difference File path
        case 'h'
            directory = strcat(directory,'/difference');
end

connectivityGraphLoc = '';

if(similarityMeasureChoice == 'f' || similarityMeasureChoice == 'g' || similarityMeasureChoice == 'h')
    connectivityGraphLoc = input('Please enter the location of connectivity graph : ', 's');
end

arrUniqueWords = [];
idfArray = [];

% Compute the idf scores for similarity measures f g h
if(similarityMeasureChoice == 'f' || similarityMeasureChoice == 'g' || similarityMeasureChoice == 'h')
    [arrUniqueWords, idfArray] = getTermIDF(datasetDir);
end

% Generating the simulation-simulation similarity matrix
dirPath = strcat(directory,'/*.csv');
filesRead = dir(dirPath);
[rowSize,columnSize] = size(filesRead);
simSimSimilarityMatrix = zeros(rowSize,rowSize);
simSimSimilarityMatrix = simSimSimilarityMatrix + 1;
% Choosing a pivot element
for i = 1:rowSize
   FirstFilePath=strcat(directory,'/',(filesRead(i).name));
   [pathstr,namei,ext] = fileparts(filesRead(i).name); 
   for j=i+1:rowSize
       SecondFilePath=strcat(directory,'/',(filesRead(j).name));
       [pathstr,namej,ext] = fileparts(filesRead(j).name); 
       if(i~=j)
            simSimSimilarityMatrix(str2num(namei),str2num(namej)) = getChoiceSimulationSimilarity( FirstFilePath, SecondFilePath, similarityMeasureChoice, connectivityGraphLoc, arrUniqueWords, idfArray);
            simSimSimilarityMatrix(str2num(namej),str2num(namei)) = simSimSimilarityMatrix(i,j);
       end
   end
end

[U,S,V] = svd(simSimSimilarityMatrix,'econ');
% Displaying the semantic scores
[rSize,cSize] = size(U);
for p=1:r
    tempMatrix = U(:,p);
    for k=1:rSize
        tempMatrix(k,2)=k;
    end
    sortedMatrix=sortrows(tempMatrix,-1);
    str = strcat ('Semantic--> ', num2str(p));
    disp(str);
    disp(sortedMatrix);
    if(p==1)
        semanticScoreMatrix = sortedMatrix;
    else
        semanticScoreMatrix=horzcat(semanticScoreMatrix,sortedMatrix);
    end
end
toc;