function y = cell2str(x)
% CELL2STR Converts a cell array to a character array
%
%   Y = matrix2str(X) converts the cell array X={'a' 2 3; 4 5 '6'} into
%   the string '{'a' 2 3; 4 5 '6']}' so that X==eval(Y).
%
% See also: misc/struct2xml, misc/matrix2str

import misc.matrix2str;
import misc.struct2xml;

if nargin < 1 || ~iscell(x), 
    error('misc:cell2str:invalidInput', ...
        'A cell array is expected as input argument.');
end

y = '';
for i = 1:size(x,1)
    for j = 1:size(x,2)
        if isstruct(x{i,j}),
            tmp = struct2xml(x{i,j});
        elseif isnumeric(x{i,j}),
            tmp = matrix2str(x{i,j});
        elseif ischar(x{i,j}),
            tmp = ['''' x{i,j} ''''];
        elseif iscell(x{i,j}),
            tmp = cell2str(x{i,j});
        else
            error('misc:cell2str:invalidType',...
                'Unknown type in cell (%d,%d).', i, j);
        end
        y = [y tmp ' , ']; 
    end
    
    % Remove trailing ,
    y(end-2:end) = '';
    
    y = [y ' ; ']; %#ok<*AGROW>
end
% Remove trailing ;
y(end-2:end)='';
y = ['{ ' y ' }'];

