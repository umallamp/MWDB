% Get all the inputs requried for the task
datasetDir = input('Enter the directory of word files : ','s');
bitsPerVector = input('Enter the number of bits per dimensions : ');

% create the index structure
[ fileApproxIndex, bitsPerDims, fileSize, reCreateMatrix, features, colIndexVector, minValues, maxValues, boundaries, dataSetRegions, reducedDataMatrix ] = getIndexStructure( bitsPerVector, datasetDir );

% print the size of the index structure
disp(strcat('Size of index structure file is = ', num2str(fileSize)));

while(true)
    % read the query word file
    queryDir = input('Enter the directory of query file : ','s');
    neighbourCount = input('Enter the t most similar files required :');
    
    queryWordFile = importdata(queryDir, ',', 0);
    
    % find the nearest neighbours
    [ neighbours, vectorsExpanded, reducedQueryVector ] = getNearestNeighbours( queryWordFile, neighbourCount, 120, features, colIndexVector, reCreateMatrix, minValues, maxValues, bitsPerDims, boundaries, dataSetRegions, reducedDataMatrix );
    disp(strcat('Number of vectors expanded using first algorithm = ', num2str(vectorsExpanded)));
    disp('Top similar files using first algorithm are :')
    disp(neighbours);
    
    % find the nearest neighbours
    [ neighbours, vectorsExpanded, ~ ] = getOptimalNearestNeighbours( queryWordFile, neighbourCount, features, colIndexVector, reCreateMatrix, minValues, maxValues, bitsPerDims, boundaries, dataSetRegions, reducedDataMatrix );
    disp(strcat('Number of vectors expanded using second algorithm = ', num2str(vectorsExpanded)));
    disp('Top similar files using second algorithm are :')
    disp(neighbours);
    
    
end