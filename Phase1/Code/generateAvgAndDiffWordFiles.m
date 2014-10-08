function [connectivityGraph, epidemicAvgFile, epidemicDiffFile ] = generateAvgAndDiffWordFiles( graphPath, wordfilePath, alphaValue )

% indexes required for operation
metaDataStartIndex = 1;
metaDataEndIndex = 3;
windowStartIndex = 4;

% predefined variables
states = 51;
delimiterIn = ',';
headerlinesIn = 1;

% create the ouput files if does not exists
if(~isequal(exist(strcat(wordfilePath, '/average'), 'dir'),7))
    mkdir(strcat(wordfilePath, '/average'));
end

if(~isequal(exist(strcat(wordfilePath, '/difference'), 'dir'),7))
    mkdir(strcat(wordfilePath, '/difference'));
end

% read the connectivity graph and epidemic word file
connectivityGraph = importdata(graphPath, delimiterIn, headerlinesIn);
directoryFiles = dir(strcat(wordfilePath, '/output/*.csv'));

for fileId = 1 : length(directoryFiles)
    rootfileName = strtok(directoryFiles(fileId, 1).name, '_');
    epidemicWordFile = importdata(strcat(wordfilePath, '/output/', directoryFiles(fileId, 1).name), delimiterIn);
    
    % split the epidemic word file into 3 dimensional matrix where each
    % dimension corresponds to a state
    [row, col] = size(epidemicWordFile);
    stateWords = permute(reshape(epidemicWordFile',[col, row/states, states]),[2,1,3]);
    
    stateFactor = row/states;
    epidemicAvgFile = zeros(row, col);
    epidemicDiffFile = zeros(row,col);
    
    % calculate the average window for the neighbours of the state
    for state = 1 : states
        windowAvg = [];
        % windowAvg = zeros(row/states, col);
        windowSum = zeros(row/states, col);
        neighbours = find(connectivityGraph.data(state, :));
        if(~isempty(neighbours))
            for id = 1 : length(neighbours)
                windowSum = windowSum + stateWords(:,:,neighbours(id));
            end
            windowAvg = [windowAvg; (windowSum / length(neighbours))];
        else
            % windowAvg = [windowAvg; stateWords(:, :, state)];
            windowAvg = [windowAvg; windowSum];
        end
        % generate data for epidemic_word_file_avg.csv file
        epidemicAvgFile((stateFactor * (state - 1) + 1) :(state * stateFactor), windowStartIndex : col) = (alphaValue * epidemicWordFile((stateFactor * (state - 1) + 1) :(state * stateFactor), windowStartIndex : col)) + ((1 - alphaValue) * windowAvg(:, windowStartIndex : col));
        % generate data for epidemic_word_file_diff.csv file
        epidemicDiffFile((stateFactor * (state - 1) + 1) :(state * stateFactor), windowStartIndex : col) = (epidemicWordFile((stateFactor * (state - 1) + 1) :(state * stateFactor), windowStartIndex:col) - windowAvg(:, windowStartIndex:col)) ./ epidemicWordFile((stateFactor * (state - 1) + 1) :(state * stateFactor), windowStartIndex:col);
        
    end
    
    % generate epidemic average and difference files
    epidemicAvgFile(:, metaDataStartIndex:metaDataEndIndex) = epidemicWordFile(:, metaDataStartIndex:metaDataEndIndex);
    epidemicDiffFile(:, metaDataStartIndex:metaDataEndIndex) = epidemicWordFile(:, metaDataStartIndex:metaDataEndIndex);
    csvwrite(strcat(wordfilePath,'/average/', rootfileName, '_epidemic_word_file_avg.csv'), epidemicAvgFile);
    csvwrite(strcat(wordfilePath,'/difference/', rootfileName, '_epidemic_word_file_diff.csv'), epidemicDiffFile);
end
end