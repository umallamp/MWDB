function drawRectangle( connectivityGraph, choice, stateId, iteration, windowSize, stateIndexes )

% define variables
width = windowSize;
stateLengthFactor = 0.8;

% Define the colors of state and neighbour
if(strcmp(choice,'max'))
    faceColor = 'y';
    mainStateColor = 'y';
    neighbourColor = 'y';
else
    if(strcmp(choice,'min'))
        faceColor = 'g';
        mainStateColor = 'g';
        neighbourColor = 'g';
    end
end

% Draw annotation for main state
rectangle('Position', [iteration (stateId -0.4)  width stateLengthFactor], 'EdgeColor', mainStateColor, 'FaceColor', faceColor);
text(iteration + width + 1, (stateId - 0.1), stateIndexes(stateId), 'Color', 'w');

% Draw annotations for neighbours
neighbours = find(connectivityGraph.data(stateId, :));
for index = 1 : length(neighbours)
    %     position_Y = neighbours(index) * stateLengthFactor;
    rectangle('Position', [iteration (neighbours(index) - 0.4) width stateLengthFactor], 'EdgeColor', neighbourColor);
    text(iteration + width + 1, (neighbours(index) - 0.1), stateIndexes(neighbours(index)), 'Color', 'w');
end
end

