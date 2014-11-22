%loadlibrary GibbsSamplerLDA.dll;
prompt = 'Input the folder for input data files: ';
directory = input(prompt,'s');

prompt = 'Input the value for r: ';
r = input(prompt);
clear mapObj;
clear arrWords;

dirPath = strcat(directory,'\*.csv');
filesRead = dir(dirPath);
[rowSize,columnSize] = size(filesRead);
mapObj = containers.Map();
%Loop for normalizing the data
tic;
for k=1:rowSize
   fileName=strcat(directory,'/',(filesRead(k).name));
   dataForFile = csvread(fileName,0,3);
   [rSize,cSize] = size(dataForFile);
   
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

arrWords = keys( mapObj);
[rSizeArrWords,cSizeArrWords] = size(arrWords);
wordFreqMatrix = zeros (rowSize, cSizeArrWords);
for k=1:rowSize
    
    mapObjPerFile = containers.Map();
    fileName=strcat(directory,'/',(filesRead(k).name));
    [pathstr,name,ext] = fileparts(filesRead(k).name); 
    dataForFile = csvread(fileName,0,3);
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
fileNameToSave=strcat(directory,'/','input.txt');
dlmwrite(fileNameToSave,inputWords,' ',0,0);
[ WS , DS ]=importworddoccounts(fileNameToSave,0,'test');

disp(WS);
disp(DS);
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
disp(WP);
disp(DP);
disp(Z);

[rSize,cSize] = size(DP);
q=0;
for p=1:r
    tempMatrix = U((q*noOfDocs)+1:(q*noOfDocs)+noOfDocs,2);
    for k=1:rSize
        tempMatrix(k,2)=k;
    end
    sortedMatrix=sortrows(tempMatrix,-1);
    str = strcat ('Semantic ', num2str(p));
    disp(str);
    disp(sortedMatrix);
    if(p==1)
        semanticScoreMatrix = sortedMatrix;
    else
        semanticScoreMatrix=horzcat(semanticScoreMatrix,sortedMatrix);
    end
end

toc;
    