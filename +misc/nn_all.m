function [idx, dist] = nn_all(a, b)
%
% a source set of points
% b target set of points

import misc.nn_all;

if nargin < 2,
    % NN to every other point, except itself
    idx = nan(size(a,1),1);
    dist = nan(size(a,1),1);
    for i = 1:size(a,1)
        thisIdx = setdiff(1:size(a,1), i);
        b = a(thisIdx, :);
        [idx(i), dist(i)] = nn_all(a(i,:), b);        
        idx(i) = thisIdx(idx(i));
    end
    return    
    
end

import misc.euclidean_dist;

dist = nan(size(a,1),1);
idx = nan(size(a,1),1);
for i = 1:size(a,1)
    allDist = euclidean_dist(a(i,:), b);
    [dist(i), idx(i)] = min(allDist);
end


end