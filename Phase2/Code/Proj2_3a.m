% Reading the directory path from user
prompt = 'Please enter a directory: ';
directory = input(prompt,'s');
% Reading value of r(number of latent semantics) from user
prompt = 'Please enter the value of r:';
r = input(prompt);
clear mapObj;
clear arrWords;

dirPath = strcat(directory,'/*.csv');
filesRead = dir(dirPath);
[rowSize,columnSize] = size(filesRead);
mapObj = containers.Map();
% Constructing a HashMap to hold all the unique values
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
% Generatingthe binary vectors of each file
arrWords = mapObj.keys;
[rSizeArrWords,cSizeArrWords] = size(arrWords);
binaryVectorMatrix = zeros (rowSize, cSizeArrWords);
for k=1:rowSize
    %disp('I am here');
    mapObjPerFile = containers.Map();
    fileName=strcat(directory,'/',(filesRead(k).name));
    [pathstr,name,ext] = fileparts(filesRead(k).name); 
    dataForFile = csvread(fileName,0,1);
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
% Calling SVD function
[U,S,V] = svd(binaryVectorMatrix,'econ');

[rSize,cSize] = size(U);
% Displaying the semantic scores
for p=1:r
    tempMatrix = U(:,p);
    for k=1:rSize
        tempMatrix(k,2)=int64(k);
    end
    sortedMatrix=sortrows(tempMatrix,-1);
    str = strcat('Semantic-->', num2str(p));
    disp(str);
    str=strcat('~~~Score~~~~Simulation~~~');
    disp(str);
    disp(sortedMatrix);
    if(p==1)
        semanticScoreMatrix = sortedMatrix;
    else
        semanticScoreMatrix=horzcat(semanticScoreMatrix,sortedMatrix);
    end
end

    