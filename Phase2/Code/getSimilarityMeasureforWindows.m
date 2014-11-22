function [ similarity ] = getSimilarityMeasureforWindows(fileName1,fileName2)
dataForFile1 = csvread(fileName1,0,3);  % Without considering state and time
dataForFile2 = csvread(fileName2,0,3);  % Without considering state and time

clear mapObj;
clear similarity;

% Get unique rows in both the files
%uniqueFirstFileWords = unique(firstFileData(:,4:colCount), 'rows');
%uniqueSecondFileWords = unique(secondFileData(:,4:colCount), 'rows');

%if(all(uniqueFirstFileWords(i,:) == uniqueSecondFileWords(j,:)))

[rowSize,columnSize] = size(dataForFile1);
mapObj = containers.Map();
mapObj1 = containers.Map();
mapObj2 = containers.Map();
k=1;
intermediateString = '';
for i=1:rowSize
    intermediateString = mat2str(dataForFile1(i,:));
    if(~isKey(mapObj,intermediateString))
        mapObj(intermediateString) = 1;
    end
    if(~isKey(mapObj1,intermediateString))
        mapObj1(intermediateString) = 1;
    end
end

[rowSize,columnSize] = size(dataForFile2);
for i=1:rowSize
    intermediateString = mat2str(dataForFile2(i,:));
    if(~isKey(mapObj,intermediateString))
        mapObj(intermediateString) = 1;
    end
    if(~isKey(mapObj2,intermediateString))
        mapObj2(intermediateString) = 1;
    end
end
%disp(mapObj.keys);

clear binVector3;
clear similarity;
arrWords = mapObj.keys;

[rSize,cSize] = size(arrWords);
binVector1 = zeros(1,cSize);
binVector2 = zeros(1,cSize);
%disp(arrWords(1));

for i=1:cSize
    if(isKey(mapObj1,arrWords(i)))
        binVector1(i) = 1;
    end
    if(isKey(mapObj2,arrWords(i)))
        binVector2(i) = 1;
    end
end
binVector3 = binVector1 .* binVector2;
similarity = sum(binVector3,2);
end