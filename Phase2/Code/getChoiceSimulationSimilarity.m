function [ similarity ] = getChoiceSimulationSimilarity( FirstFilePath, SecondFilePath, Choice )
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
            similarity = getEpidemicWordSimilarity(FirstFilePath, SecondFilePath);
            % Average File Distance
        case 'd'
            similarity = getEpidemicWordSimilarity(FirstFilePath, SecondFilePath);
            % Difference File Distance
        case 'e'
            similarity = getEpidemicWordSimilarity(FirstFilePath, SecondFilePath);
    end
end

