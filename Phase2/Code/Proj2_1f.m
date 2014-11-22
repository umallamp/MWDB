function similarity = Proj2_1f(file1,file2,connectivityGraphLoc,arrUniqueWords,idfArray)
% dirName = input('Input the folder for input data files: ','s');
% 
% file1 = input('Enter the input for File - 1 ','s');
% 
% file2 = input('Enter the input for File - 2 ','s');
% 
% connectivityGraphLoc = input('Enter the connectivity Graph location ','s');

%prepare connectivity matrix from the input

% The program takes as input the directory name of the epidemic simulation
% files , the file name file1 and file 2 taken as inputs,the connectivity
% matrix and the value of values of unique words and idfarray returned by
% the getTermIdf function. 

[dirName, ~, ~] = fileparts(file1);

files = dir(fullfile(dirName));

dirIndex = [files.isdir];  %# Find the index for directories
fileList = {files(~dirIndex).name} ;

connectivtyMatrix = importdata(connectivityGraphLoc);

connectivtyMatrix = connectivtyMatrix.data;

%contains the file 1 data excluding the file numbers
f1Matrix = csvread(file1,0,1);

%contains the file 2 data excluding the file numbers
f2Matrix = csvread(file2,0,1);

[f1rows,~] = size(f1Matrix);

[f2rows,~] = size(f2Matrix);

%create the string matrix of words
for i=1:f1rows
    word1Matrix{i,1} = mat2str(f1Matrix(i,3:end));
end

%create the string matrix of words 2
for i=1:f1rows
    word2Matrix{i,1} = mat2str(f2Matrix(i,3:end));
end

%once we have the connectivity matrix, obtain the bfs values for each
%nodes

bfsMatrix = bfs(connectivtyMatrix);

%initialize the binary vector w1
w1 = ones(1,f1rows);

%initialize the binary vector w2
w2 = ones(f2rows,1);

% the shortest path between the states would be obtained from the
% matrix


% find out how discriminating the words are in the entire db
%for this maintain the idf score of all the words in the entire corpus
% [arrUniqueWords,idfArray] = getTermIDF(dirName);

%docSize = length(fileList);
%declare the A matrix;
AMatrix = zeros(f1rows,f2rows);
scount=0;
for i=1:f1rows
    
    %get the state and time values and then obtain the words
    state1Id = f1Matrix(i,1);
    iteration1 = f1Matrix(i,2);
    word1 = f1Matrix(i,3:end);
    [~,rowIndex] = ismember(word1,arrUniqueWords,'rows');
    if (rowIndex==0)
        idfcount1=log10(length(fileList)/1);
    else
        idfcount1 = idfArray(rowIndex,1);
    end
    
    for j=1:f2rows
        % now we have both the words hence perform req calculations
        ssCloseness = bfsMatrix(state1Id,f2Matrix(j,1));
        
        if ~isinf(ssCloseness)
            %scope of making mistake
            word2 = f2Matrix(j,3:end);
            if(isequal(word1,word2))
                idfcount2=idfcount1;
            else
                [~,row2Index] = ismember(word2,arrUniqueWords,'rows');
                idfcount2 = idfArray(row2Index,1);
            end
            value = (1/(1+(abs(iteration1-f2Matrix(j,2)))))*(1/1+ssCloseness)*((idfcount2+idfcount1)/2);
            if ~(isinf(value) || isnan(value))
                scount=scount+value;
                AMatrix(i,j) = value;
            end
        end
    end
end
%display(AMatrix);
similarity = w1 * AMatrix * w2;
end