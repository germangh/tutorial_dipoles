function y = isnatural(x)
% isnatural - True for natural numeric arrays
%
% test = isnatural(x)
%
% Where
%
% X is a numeric array.
%
% TEST is true if all the elements of X are natural numbers. Otherwise,
% TEST is false.
%
% Dependencies:
%
% misc.isinteger
%
% 
% See also: misc.isinteger

import misc.isinteger;

y = isinteger(x) & all(x > 0);


end