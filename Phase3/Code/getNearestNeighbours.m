function [ output_args ] = getNearestNeighbours( vectorApproxIndex, queryVector, neighbours, totalFileCount )

neighbourFiles = zeros(neighbours);
neighbourDist = Inf(neighbours);

lowerBound = zeros(neighbours);
upperBound = zeros(neighbours);

for fileId = 1 : totalFileCount
    lowerBound(fileId) = getBounds(
    

end
end

function getBounds(fileApprox, queryVector)

lowerBound = 0;
upperBound = 0;

dimensions = length(queryVector);
for dim = 1 : dimensions
    

end
