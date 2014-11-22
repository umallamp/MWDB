function [uniqueWords,idfArray] = getTermIDF(dirName)
files = dir(fullfile(dirName));

dirIndex = [files.isdir];  %# Find the index for directories
fileList = {files(~dirIndex).name} ;
%map contains the list of all the words and the number of documents it is present in
uniqueWordFiles = [];

[~,name,ext] = fileparts(fileList{1});
fName = strcat(dirName,'\',name,ext);
%get the filenames and then iterate and add each word
dataForFile = csvread(fName,0,3);
[rSize,cSize] = size(dataForFile);
%initialize the set
wordSlice  = zeros(rSize,cSize,length(fileList));
uniqueWordFiles = [uniqueWordFiles; unique(dataForFile, 'rows')];
wordSlice(:,:,1) = dataForFile;


for i=2:length(fileList)
    [~,name,ext] = fileparts(fileList{i});
    fName = strcat(dirName,'\',name,ext);
    %get the filenames and then iterate and add each word
    dataForFile = csvread(fName,0,3);
    %initialize the set
    uniqueWordFiles = [uniqueWordFiles; unique(dataForFile, 'rows')];
    wordSlice(:,:,i) = dataForFile;
end

uniqueWords = unique(uniqueWordFiles, 'rows');

[uRows,~] = size(uniqueWords);

%create unique words for
idfArray = zeros(uRows,1);

for i=1:uRows
    for j=1:length(fileList)
        [isPresent,~] = ismember(uniqueWords(i,:),wordSlice(:,:,j),'rows');
        if(isPresent)
           idfArray(i,1) =  idfArray(i,1)+1;
        end
    end
    idfArray(i,1) = log10(length(fileList)/idfArray(i,1));
end
end