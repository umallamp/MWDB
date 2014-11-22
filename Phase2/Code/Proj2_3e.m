function [] = Proj2_3e()
%loadlibrary GibbsSamplerLDA.dll;
% Reading the directory path from user
prompt = 'Input the folder for input data files: ';
directory = input(prompt,'s');
% Reading value of r(number of latent semantics) from user
prompt = 'Input the value for r: ';
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
%Loop for normalizing the data

for k=1:rowSize
   fileName=strcat(directory,'/',(filesRead(k).name));
   dataForFile = csvread(fileName,0,3);
   [rSize,cSize] = size(dataForFile);
   % Constructing a HashMap to hold all the unique values
   for i=1:rSize
            intermediateString = mat2str(dataForFile(i,:));
%             disp(intermediateString);
            %intermediateString = strcat(intermediateString,num2str(dataForFile1(i,j)),',');
        if(~isKey(mapObj,intermediateString))
            mapObj(intermediateString) = 1;            
        else
%              disp(mapObj(intermediateString));
             mapObj(intermediateString) = mapObj(intermediateString)+1; 
%              disp(mapObj(intermediateString));
        end
   end
end

% For the query file
dirPathQueryFile = strcat(directoryQueryFile,'\*.csv');
% disp(dirPathQueryFile);
filesReadQuery = dir(dirPathQueryFile);
% Adding new keys of query file to mapObj
fileNameQuery=strcat(directoryQueryFile,'\',(filesReadQuery(1).name));
% disp(fileNameQuery);
% disp(filesReadQuery(1).name);
   dataForFileQuery = csvread(fileNameQuery,0,3);
   [rSize,cSize] = size(dataForFileQuery);
   
   for i=1:rSize
            intermediateString = mat2str(dataForFileQuery(i,:));
            %intermediateString = strcat(intermediateString,num2str(dataForFile1(i,j)),',');
        if(~isKey(mapObj,intermediateString))
            mapObj(intermediateString) = 1;
        else
             mapObj(intermediateString) = mapObj(intermediateString)+1; 
        end
   end
rowSize = rowSize + 1;
queryFileNumber = rowSize;
% Generating the word frequency matrix of each file
arrWords = keys( mapObj);
[rSizeArrWords,cSizeArrWords] = size(arrWords);
wordFreqMatrix = zeros (rowSize, cSizeArrWords);
for k=1:rowSize
    
    mapObjPerFile = containers.Map();
     % For the query file
    if(k==queryFileNumber)
        %fileName=strcat(directoryQueryFile,'/',(filesRead(k).name));
        dataForFile = csvread(fileNameQuery,0,3);
        name = num2str(queryFileNumber);
   % For all other files
    else
        fileName=strcat(directory,'/',(filesRead(k).name));
        [pathstr,name,ext] = fileparts(filesRead(k).name);
        dataForFile = csvread(fileName,0,3);
    end
%     uniqueFileWords = unique(dataForFile, 'rows');
    [rSizeUniq,cSizeUniq] = size(dataForFile);
    for i = 1:rSizeUniq
        intermediateString = mat2str(dataForFile(i,:));
%         disp(intermediateString);
        if(~isKey(mapObjPerFile,intermediateString))
            mapObjPerFile(intermediateString) = 1;
        else
%             disp(mapObjPerFile(intermediateString));
            mapObjPerFile(intermediateString) = mapObjPerFile(intermediateString)+1;
        end
    end
   
   
    for i=1:cSizeArrWords
        if(isKey(mapObjPerFile,arrWords(i)))
            intermediateString =arrWords{i};
            wordFreqMatrix(str2num(name),i) = mapObjPerFile(intermediateString);            
        else
            wordFreqMatrix(str2num(name),i) = 0;
        end
    end
end

% lambda=eig(binaryVectorMatrix);
% disp(lambda);
% [U,S,V] = svd(wordFreqMatrix);

% disp(wordFreqMatrix);
% disp(sum(wordFreqMatrix,2));
% disp(U);
% disp(S);
% disp(V);

% disp(U*S*V);

[noOfDocs,noOfFeatures]=size(wordFreqMatrix);
weightageMatrix=wordFreqMatrix; 
% zeros(noOfDocs,noOfFeatures);

logFreqArray=zeros(1,noOfFeatures);

for i=1:noOfFeatures
    clear nonZeroVector;
    clear countDocs;
    nonZeroVector= find(weightageMatrix(:,i));
    countDocs=size(nonZeroVector,1);  
    logFreqArray(i)=log(noOfDocs/countDocs);
    weightageMatrix(:,i)=weightageMatrix(:,i)*logFreqArray(i);
end

% for i=1:noOfDocs
%     for j=1:noOfFeatures
%         weightageMatrix(:,j)=weightageMatrix(:,j)*logFreqArray(j);
%     end
% end

% disp(weightageMatrix);
% Generating the input matrix for LDA to process
rowCounter=1;
for i=1:noOfDocs
    for j=1:noOfFeatures
        inputWords(rowCounter,1)=i;
        inputWords(rowCounter,2)=j;
        inputWords(rowCounter,3)=(wordFreqMatrix(i,j));
        rowCounter=rowCounter+1;
    end
end
%disp(inputWords);
fileNameToSave=strcat(directory,'/','input1.txt');
dlmwrite(fileNameToSave,inputWords,' ',0,0);
[ WS , DS ]=importworddoccounts(fileNameToSave,0,'test');

% disp('WS');
% disp(WS);
% disp('DS');
% disp(DS);
%%
% Set the number of topics
T=r; 

%%
% Set the hyperparameters
BETA=200/noOfFeatures;
ALPHA=50/T;

%%
% The number of iterations
N = 500; 

%%
% The random seed
SEED = 3;

%%
% What output to show (0=no output; 1=iterations; 2=all output)
OUTPUT = 2;

%%
% This function might need a few minutes to finish
[ WP,DP,Z ] = GibbsSamplerLDA( WS , DS , T , N , ALPHA , BETA , SEED , OUTPUT );
% disp('WP');
% disp(WP);
% disp('DP');
% disp(DP);
%disp('Z');
%disp(Z);

% disp(DP(1,1))

[rSize,cSize] = size(DP);
% disp(rSize);
% disp(cSize);
q=0;

for i=1:noOfDocs
    for j = 1:r
        clear C;
        C = DP(i,j);
        weightedMatrix(i,j) = C;
    end
end
% disp(weightedMatrix);
% Displaying the semantic scores
for p=1:r
    %tempMatrix((q*noOfDocs)+1:(q*noOfDocs)+noOfDocs,1) = DP((q*noOfDocs)+1:(q*noOfDocs)+noOfDocs,2);
    %disp( DP((q*noOfDocs)+1:(q*noOfDocs)+noOfDocs,2));
    clear tempMatrix;
    clear sortedMatrix;
    tempMatrix = weightedMatrix(:,p);
    for k=1:noOfDocs
        tempMatrix(k,2)=k;
    end
    sortedMatrix=sortrows(tempMatrix,-1);
    str = strcat ('Semantic--->', num2str(p));
    disp(str);
  
    [rVal,cVal]=size(sortedMatrix);
    
%     disp(sortedMatrix);
   
%     if(p==1)
%         semanticScoreMatrix = sortedMatrix;
%     else
%         semanticScoreMatrix=horzcat(semanticScoreMatrix,sortedMatrix);
%     end
        
    SubtractMatrix(:,1) = tempMatrix(:,1) - tempMatrix(queryFileNumber,1);
    SubtractMatrix(:,2)=tempMatrix(:,2);
    SubtractMatrixQuery = abs(SubtractMatrix);
    sortedSubtractMatrixQuery = sortrows(SubtractMatrixQuery);
   
    [rSizeQuery,cSizeQuery] = size(sortedSubtractMatrixQuery);
    if(kn+1>rSizeQuery)
        kNearestMatrix = sortedSubtractMatrixQuery(2:rSizeQuery,:);
    else
        kNearestMatrix = sortedSubtractMatrixQuery(2:kn+1,:);
    end
    str=strcat('~~~Index~~~~Score~~~Index~~~Simulation');
    disp(str);
    disp(kNearestMatrix);
end


end
    