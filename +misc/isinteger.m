function y = isinteger(x)
% isinteger - True for natural numeric arrays
%
% test = isinteger(x)
%
% Where
%
% X is a numeric array.
%
% TEST is true if all the elements of X are integer numbers. Otherwise,
% TEST is false.
%
% #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  #
% # The misc package for MATLAB                                           #
% # German Gomez-Herrero <german.gomezherrero@ieee.org>                   #
% # Netherlands Institute for Neuroscience                                #
% # Amsterdam, The Netherlands                                            #
% #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  #
%
% See also: misc.isnatural

y = isinteger(x);
if y,
    return;
end


y = all(isnumeric(x) & abs(x-round(x))<eps);


end