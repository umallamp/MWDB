function [ entireWords, uniqueWords, dataMatrix ] = getSVDReducedSpace( datasetDir, r )

delimiterIn = ',';
headerlinesIn = 0;
directoryFiles = dir(strcat(datasetDir,'/*.csv'));

[rowSize,columnSize] = size(filesRead);
mapObj = containers.Map();

% Constructing a HashMap to hold all the unique values
for k=1:rowSize
    fileName=strcat(directory,'/',(directoryFiles(k).name));
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
