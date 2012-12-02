function y = matrix2str(x)
% MATRIX2STR Converts a numeric matrix to a character array
%
%   Y = matrix2str(X) converts the array X=[1 2 3; 4 5 6] into the char
%   array '[1 2 3; 4 5 6]' so that X==eval(Y).
%
% See also: misc/struct2xml, misc/cell2str


y = num2str(x);
if size(y,1) > 1,
    tmp = [];
    for j = 1:size(y,1),
        tmp = [tmp ' ; ' y(j,:)]; %#ok<AGROW>
    end
    tmp(1:3) = [];
    y = ['[ ' tmp ' ]'];
end