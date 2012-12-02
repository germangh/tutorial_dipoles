function disp(obj)
% DISP - Displays information about a @hash object

keys = obj.Hashtable.keys();
count = 0;
if (keys.hasMoreElements())
    thisKey = char(keys.nextElement());
    keyStr = sprintf('%s(%s), ', thisKey, ...
        char(obj.Class.get(thisKey)));
    count = count + 1;
else
    keyStr = ''; 
end
while(keys.hasMoreElements())
   thisKey = char(keys.nextElement());
   thisKeyStr = sprintf('%s(%s), ', thisKey, ...
        char(obj.Class.get(thisKey))); 
   keyStr = [keyStr thisKeyStr ','];  %#ok<AGROW>
   count = count + 1;
end
if numel(keyStr)>2, keyStr(end-1:end) = []; end

fprintf('%s =\n\n', inputname(1));
fprintf('\t<a href="matlab:help misc.hash">misc.hash</a> with %d keys\n\n', ...
    count);
if ~isempty(keyStr),
    fprintf('\tkey(value): %s\n\n', keyStr);
end




end