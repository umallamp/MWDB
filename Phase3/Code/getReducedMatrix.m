function [ reducedMatrix ] = getReducedMatrix( normalizedMatrix )

[u, s, v] = svd(normalizedMatrix);

end

