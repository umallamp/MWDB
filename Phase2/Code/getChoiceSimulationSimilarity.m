function [ similarity ] = getChoiceSimulationSimilarity( FirstFilePath, SecondFilePath, Choice, connectivityGraphLoc, arrUniqueWords, idfArray )
% Get the similarity score based on the user choice
    switch Choice
        % Eculedian Distance
        case 'a'
            similarity = getEuclideanSimilarity(FirstFilePath, SecondFilePath);
            % Dynamic Tme Wrapping Distance
        case 'b'
            similarity = getDTWSimilarity(FirstFilePath, SecondFilePath);
            % Word File Distance
        case 'c'
            similarity = getSimilarityMeasureforWindows(FirstFilePath, SecondFilePath);
            % Average File Distance
        case 'd'
            similarity = getSimilarityMeasureforWindows(FirstFilePath, SecondFilePath);
            % Difference File Distance
        case 'e'
            similarity = getSimilarityMeasureforWindows(FirstFilePath, SecondFilePath);
            % Word File Distance with A Matrix
        case 'f'
            similarity = Proj2_1f(FirstFilePath, SecondFilePath, connectivityGraphLoc, arrUniqueWords, idfArray);
            % Difference File Distance with A Matrix
        case 'g'
            similarity = Proj2_1f(FirstFilePath, SecondFilePath, connectivityGraphLoc, arrUniqueWords, idfArray);
            % Difference File Distance with A Matrix
        case 'h'
            similarity = Proj2_1f(FirstFilePath, SecondFilePath, connectivityGraphLoc, arrUniqueWords, idfArray);
    end
end

