function [ similarity ] = getDTWDistance( FirstFileState, SecondFileState )

% Get the lenght of the first state array and second state array
fLength = length(FirstFileState);
sLength = length(SecondFileState);

% Initialize the DTWMatrix with inifinity
DTWMatrix = Inf(fLength, sLength);

DTWMatrix(1, 1) = 0;

% Compute the distance between two array that minimizes the cost 
for i = 2 : fLength
    for j = 2 : sLength
        cost = (FirstFileState(i) - SecondFileState(j)).^2;
        DTWMatrix(i,j) = cost + min([DTWMatrix(i-1,j) DTWMatrix(i,j-1) DTWMatrix(i-1,j-1)]);
    end
end

% retrun the final similarity
similarity = DTWMatrix(fLength, sLength);

end

