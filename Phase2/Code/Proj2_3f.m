% Reading the directory path from user
prompt = 'Please enter the directory for epidemic simulation files:';
directory = input(prompt,'s');
% Reading value of r(number of latent semantics) from user
prompt = 'Please enter a value for number of latent semantics (r) :';
r = input(prompt);

%Directory of query file
prompt = 'Please enter a directory for query file: ';
directoryQueryFile = input(prompt,'s');
%K nearest neighbour value
prompt = 'Please enter the value of k(number of nearest neighbors):';
kn = input(prompt);

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

dirPath = strcat(directory,'/*.csv');
filesRead = dir(dirPath);
[rowSize,columnSize] = size(filesRead);
rowSize = rowSize + 1;
queryFileNumber = rowSize;
simSimSimilarityMatrix = zeros(rowSize,rowSize);
simSimSimilarityMatrix = simSimSimilarityMatrix + 1;

% For the query file
dirPathQueryFile = strcat(directoryQueryFile,'/*.csv');
filesReadQuery = dir(dirPathQueryFile);

fileNameQuery=strcat(directoryQueryFile,'/',(filesReadQuery(1).name));

% Choosing a pivot element
for i = 1:rowSize
   if(i == queryFileNumber)
       FirstFilePath = fileNameQuery;
       namei = num2str(queryFileNumber);
   else
       FirstFilePath=strcat(directory,'/',(filesRead(i).name));
       [pathstr,namei,ext] = fileparts(filesRead(i).name); 
   end
   for j=i+1:rowSize
       if(j == queryFileNumber)
            SecondFilePath = fileNameQuery;
            namej = num2str(queryFileNumber);
       else
           SecondFilePath=strcat(directory,'/',(filesRead(j).name));
           [pathstr,namej,ext] = fileparts(filesRead(j).name);
       end
       if(i~=j)
            simSimSimilarityMatrix(str2num(namei),str2num(namej)) = getChoiceSimulationSimilarity( FirstFilePath, SecondFilePath, similarityMeasureChoice, connectivityGraphLoc, arrUniqueWords, idfArray);
            simSimSimilarityMatrix(str2num(namej),str2num(namei)) = simSimSimilarityMatrix(i,j);
       end
   end
end
%disp(simSimSimilarityMatrix);

[U,S,V] = svd(simSimSimilarityMatrix,'econ');

[rSize,cSize] = size(U);
for p=1:r
    clear SubtractMatrix;
    clear sortedSubtractMatrixQuery;
    % tempMatrix --> reading the latent semantic values from the U matrix
    tempMatrix = U(:,p);
    for k=1:rSize
        % tempMatrix --> assigning the file numbers to their corresponding
        % scores of latent semantics
        tempMatrix(k,2)=k;
    end
    % sortedMatrix --> sorts the temp matrix on the values of the semantic
    % scores in descending order
    %sortedMatrix=sortrows(tempMatrix,-1);
    % Displaying the semantic scores
    str = strcat ('Semantic--> ', num2str(p));
     disp(str);
%      disp(tempMatrix);
    
    % Storing all the semantic scores and their file numbers in semanticScoreMatrix
    %if(p==1)
    %    semanticScoreMatrix = sortedMatrix;
    %else
    %    semanticScoreMatrix=horzcat(semanticScoreMatrix,sortedMatrix);
    %end
    
    SubtractMatrix(:,1) = tempMatrix(:,1) - tempMatrix(queryFileNumber,1);
    SubtractMatrix(:,2)=tempMatrix(:,2);
    SubtractMatrixQuery = abs(SubtractMatrix);
    sortedSubtractMatrixQuery = sortrows(SubtractMatrixQuery);
    %disp(sortedSubtractMatrixQuery);
    [rSizeQuery,cSizeQuery] = size(sortedSubtractMatrixQuery);
    if(kn+1>rSizeQuery)
        kNearestMatrix = sortedSubtractMatrixQuery(2:rSizeQuery,2);
    else
        kNearestMatrix = sortedSubtractMatrixQuery(2:kn+1,2);
    end
    for x=1:kn
        kNearestMatrix(x,2) = tempMatrix(int64(kNearestMatrix(x,1)),1);
    end
    str=strcat('~~~Simulation~~~~Score~~~');
    disp(str);
    disp(kNearestMatrix);
    
end
toc;