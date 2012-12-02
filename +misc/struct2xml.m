function y = struct2xml(x)
% STRUCT2XML Converts a struct into an XML-encoded string
%
%   Y = struct2xml(X) where X is a struct with fields 'field1', 'field2',
%   with values value1 and value2, respectively, generates the following
%   XML string:
%
%   <struct>
%       <field1>value1</field1>   
%       <field1>value2</field1>   
%   <struct>
%
%   All property values which are not struct will be encoded as strings.
%
% See also: misc/xml2struct

import misc.struct2xml;
import misc.matrix2str;
import misc.cell2str;

%y = sprintf('<struct>\n');
y = sprintf('<struct>');
fnames = fieldnames(x);
for i = 1:length(fnames)
    if isstruct(x.(fnames{i})),
        fvalue = struct2xml(x.(fnames{i}));
    elseif isnumeric(x.(fnames{i})),
        fvalue = matrix2str(x.(fnames{i}));
    elseif ischar(x.(fnames{i})),
        fvalue = ['''' x.(fnames{i}) ''''];
    elseif iscell(x.(fnames{i})),
        fvalue = cell2str(x.(fnames{i}));
    else
        fvalue = 'null';        
    end
    %fvalue = strrep(fvalue, char(10), [char(10) char(9) char(9)]);
    %fvalue = [char(9) char(9) fvalue]; %#ok<AGROW>
    %tmp = sprintf('\t<%s>\n%s\n\t</%s>\n', fnames{i}, fvalue, fnames{i});
    tmp = sprintf('<%s>%s</%s>', fnames{i}, fvalue, fnames{i});
    y = [y tmp];             %#ok<AGROW>
end
y = [y sprintf('</struct>')];

