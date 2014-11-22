function visualizeHeatMaps( datasetDir, query, results, isSimulationFile )

delimiterIn = ',';

% Read the header lines depending on choice
if(isSimulationFile)
    headerlinesIn = 1;
else
    headerlinesIn = 0;
end

% Visualize the query
queryData = importdata(query, delimiterIn, headerlinesIn);
figure();
if(isSimulationFile)
    imagesc(queryData.data);
else
    imagesc(queryData);
end

title('Query');

[row, ~] = size(results);

% Visualize the files
for index = 1 : row
    filePath = strcat(datasetDir, '/' , num2str(results(index, 2)), '.csv');
    fileData = importdata(filePath, delimiterIn, headerlinesIn);
    figure();
    if(isSimulationFile)
        imagesc(fileData.data);
    else
        imagesc(fileData);
    end
    title(strcat(num2str(results(index, 2)), '.csv'));
end
end

