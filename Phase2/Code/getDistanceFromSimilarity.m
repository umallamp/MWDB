function [ distance ] = getDistanceFromSimilarity( similarity, similarityChoice )
% Distance funciton for similarity
epsilon = 0.000001;
if(similarityChoice == 'a' || similarityChoice == 'b')
    distance = (1 / similarity) - 1;
else
    distance = (1 / (epsilon + similarity));
end
end

