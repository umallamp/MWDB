%Directory of simulation files
prompt = 'Please enter a directory: ';
directory = input(prompt,'s');
%Number of latent semantic values
prompt = 'Please enter the value of r:';
r = input(prompt);
%Directory of query file
prompt = 'Please enter a directory for query file: ';
directoryQueryFile = input(prompt,'s');
%K nearest neighbour value
prompt = 'Please enter the value of k(number of nearest neighbors):';
kn = input(prompt);


clear mapObj;
clear arrWords;

dirPath = strcat(directory,'/*.csv');
filesRead = dir(dirPath);
[rowSize,columnSize] = size(filesRead);
mapObj = containers.Map();
% Constructing a HashMap to hold all the unique values
tic;
for k=1:rowSize
    fileName=strcat(directory,'/',(filesRead(k).name));
    dataForFile = csvread(fileName,0,1);
    [rSize,cSize] = size(dataForFile);
    
    for i=1:rSize
        intermediateString = mat2str(dataForFile(i,:));
        %intermediateString = strcat(intermediateString,num2str(dataForFile1(i,j)),',');
        if(~isKey(mapObj,intermediateString))
            mapObj(intermediateString) = 1;
        end
    end
end

% For the query file
dirPathQueryFile = strcat(directoryQueryFile,'/*.csv');
filesReadQuery = dir(dirPathQueryFile);

fileNameQuery=strcat(directoryQueryFile,'/',(filesReadQuery(1).name));
dataForFileQuery = csvread(fileNameQuery,0,1);
[rSize,cSize] = size(dataForFileQuery);

for i=1:rSize
    intermediateString = mat2str(dataForFileQuery(i,:));
    %intermediateString = strcat(intermediateString,num2str(dataForFile1(i,j)),',');
    if(~isKey(mapObj,intermediateString))
        mapObj(intermediateString) = 1;
    end
end
rowSize = rowSize + 1;
queryFileNumber = rowSize;
% Generatingthe binary vectors of each file
arrWords = mapObj.keys;
[rSizeArrWords,cSizeArrWords] = size(arrWords);
binaryVectorMatrix = zeros (rowSize, cSizeArrWords);
for k=1:rowSize
    %disp('I am here');
    mapObjPerFile = containers.Map();
    % For the query file
    if(k==queryFileNumber)
        %fileName=strcat(directoryQueryFile,'/',(filesRead(k).name));
        dataForFile = csvread(fileNameQuery,0,1);
        name = num2str(queryFileNumber);
        % For all other files
    else
        fileName=strcat(directory,'/',(filesRead(k).name));
        [pathstr,name,ext] = fileparts(filesRead(k).name); 
        dataForFile = csvread(fileName,0,1);
    end
    uniqueFileWords = unique(dataForFile, 'rows');
    [rSizeUniq,cSizeUniq] = size(uniqueFileWords);
    for i = 1:rSizeUniq
        intermediateString = mat2str(uniqueFileWords(i,:));
        if(~isKey(mapObjPerFile,intermediateString))
            mapObjPerFile(intermediateString) = 1;
        end
    end
    %disp(arrWords(1));
    
    for i=1:cSizeArrWords
        if(isKey(mapObjPerFile,arrWords(i)))
            binaryVectorMatrix(str2num(name),i) = 1;
        end
    end
end

[U,S,V] = svd(binaryVectorMatrix,'econ');

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
    str = strcat ('Semantic--> ', num2str(p));
    disp(str);
    
    
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
   
   % Displaying the semantic scores
    str=strcat('~~~Score~~~~Simulation~~~');
    disp(str);
%     disp(sortedSubtractMatrixQuery);
    [rSizeQuery,cSizeQuery] = size(sortedSubtractMatrixQuery);
    if(kn+1>rSizeQuery)
        kNearestMatrix = sortedSubtractMatrixQuery(2:rSizeQuery,:);
    else
        kNearestMatrix = sortedSubtractMatrixQuery(2:kn+1,:);
    end
    disp(kNearestMatrix);
    
end

%semanticScoreMatrix=U(:,1:r)*S(1:r,1:r)*V(1:r,:);

toc;
