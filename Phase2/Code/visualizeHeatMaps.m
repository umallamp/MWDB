function visualizeHeatMaps( datasetDir, query, results, isSimulationFile )

delimiterIn = ',';

if(isSimulationFile)
    headerlinesIn = 1;
else
    headerlinesIn = 0;
end

% Visualize the query
queryData = importdata(query, delimiterIn, headerlinesIn); 
figure();
imagesc(queryData.data);
title('Query');

% Visualize the files
for index = 1 : length(results)
    filePath = strcat(datasetDir, '/' , num2str(results(index)), '.csv');
    fileData = importdata(filePath, delimiterIn, headerlinesIn);
    figure();
    imagesc(fileData.data);
    title(strcat(num2str(results(index)), '.csv'));
end
end

