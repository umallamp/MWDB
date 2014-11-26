function [ uniqueVectorsMap ] = getVectorSpace( datasetDir )

delimiterIn = ',';
headerlinesIn = 0;
directoryFiles = dir(strcat(datasetDir,'/*.csv'));

[fileCount, ~] = size(filesRead);

% define hash map to store unique words in each word file
uniqueVectorsMap = containers.Map();

% Constructing a HashMap to hold all the unique values
for index = 1 : fileCount
    
    % get the file path
    fileName = strcat(directory, '/', (directoryFiles(index).name));
    dataForFile = importdata(fileName, delimiterIn, headerlinesIn);
    
    [rSize, ~] = size(dataForFile);
    
    for i=1:rSize
        % convert the word to string
        stringVector = mat2str(dataForFile(i,:));
        
        % insert the word into the hashmap
        if(~isKey(uniqueVectorsMap, stringVector))
            uniqueVectorsMap(stringVector) = 1;
        end
    end
end

% get all the unique words from hashmap
uniqueVectors = mapObj.keys;

[~ , colCount] = size(uniqueVectors);

binaryVectorMatrix = zeros (fileCount, colCount);
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

    for i=1:colCount
        if(isKey(mapObjPerFile,arrWords(i)))
            binaryVectorMatrix(str2num(name),i) = 1;
        end
    end
end
