function keysCell = keys(obj)

keys = obj.Hashtable.keys();
count = 0;
keysCell = cell(1,100);
while (keys.hasMoreElements())
    count = count + 1;
    keysCell{count} = char(keys.nextElement());   
end
keysCell(count+1:end) = [];


end