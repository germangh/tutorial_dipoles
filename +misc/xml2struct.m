function [out2,out] = xml2struct(xmlfile)
%XML2STRUCT Read XML file into a structure.


% German Gomez-Herrero

tmp_xmlfile = tempname;
perl('+misc/strip_spaces.pl', xmlfile, tmp_xmlfile);

xml = xmlread(tmp_xmlfile);

children = xml.getChildNodes;

nchildren = children.getLength;
c = cell(1, nchildren);
out =  struct('name',c,'attributes',c,'data',c,'children',c);
for i = 1:nchildren
    child = children.item(i-1);
    [out(i), out2.(char(child.getNodeName))] = node2struct(child);
end


delete(tmp_xmlfile);



function [s,s2] = node2struct(node)

s2=[];
s.name = char(node.getNodeName);

if node.hasAttributes
    attributes = node.getAttributes;
    nattr = attributes.getLength;
    s.attributes = struct('name',cell(1,nattr),'value',cell(1,nattr));
    for i = 1:nattr
        attr = attributes.item(i-1);
        s.attributes(i).name = char(attr.getName);
        s.attributes(i).value = char(attr.getValue);
    end
else
    s.attributes = [];
end

try
    s.data = char(node.getData);
catch %#ok<CTCH>
    s.data = '';
end

if node.hasChildNodes
    children = node.getChildNodes;
    nchildren = children.getLength;
    if nchildren==1 && strcmpi(char(children.item(0).getNodeName), '#text'),
        s.data = char(children.item(0).getData);
        s.children = [];        
        if isempty(s.data),
            s2.(s.name) = '';
        else
            s2.(s.name) = s.data;
        end
        return;
    end
    c = cell(1,nchildren);
    s.children = struct('name',c,'attributes',c,'data',c,'children',c);
    
    for i = 1:nchildren
        child = children.item(i-1);
        if strcmpi(char(child.getNodeName), '#text'),
            childData = char(child.getData);
            if ~isempty(regexpi(childData, '^\s*$')),
                % It is a dummy node
                continue;
            else                
                s.children(i).name = '#text';
                s.children(i).data = childData;
                tmp = struct('text', childData);
            end
        else
            [s.children(i), tmp] = node2struct(child);
        end
        if isfield(s2, char(child.getNodeName)),
            if isstruct(tmp) && isfield(tmp, char(child.getNodeName)),
                if numel(s2)==1 && isstruct(s2.(char(child.getNodeName))),
                    s2.(char(child.getNodeName))(end+1:end+1) = ...
                        tmp.(char(child.getNodeName));
                else
                    s2(end+1:end+1) = tmp;
                end
            else
                s2.(char(child.getNodeName))(end+1:end+1) = tmp;
                
            end
        else
            if isstruct(tmp) && isfield(tmp, char(child.getNodeName)),
                s2.(char(child.getNodeName)) = tmp.(char(child.getNodeName));
            else
                s2.(char(child.getNodeName)) = tmp;
            end
        end
    end
    
else
    s.children = [];
end