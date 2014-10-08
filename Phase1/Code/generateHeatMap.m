function generateHeatMap(originalFile, filedata, windowSize, connectivityGraph, stateIndexes)

[~ , col] = size(filedata);

% calculate the word strengths
windows = filedata(:, 4 : col);
wordStrengths = sqrt(sum(windows.^2, 2));

[~, minIndex] = min(wordStrengths);
[~, maxIndex] = max(wordStrengths);

% Randomize the state that contains minimum strength
% minWordStrengths = wordStrengths;
% 
% minWordStrengths(minWordStrengths ~= min(wordStrengths)) = 0;
% minIndices = find(minWordStrengths);
% randMinIndex = randi([1 length(minIndices)]);
% randMinState = filedata(randMinIndex, 2);

% Get the state and time that has minimum and maximum strengths
minState = filedata(minIndex,2);
minIteration = filedata(minIndex,3);
maxState = filedata(maxIndex,2);
maxIteration = filedata(maxIndex,3);

% Visualize the the states and its neighbours
imagesc(originalFile');
drawRectangle(connectivityGraph, 'min',  minState, minIteration, windowSize, stateIndexes);
drawRectangle(connectivityGraph, 'max',  maxState, maxIteration, windowSize, stateIndexes);

end