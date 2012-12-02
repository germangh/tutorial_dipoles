function B = subsref(obj, S)
% SUBSREF Subscripted reference for class @hash
switch S(1).type
    case '()'        
        if numel(S(1).subs) == 1 && iscell(S(1).subs) && ...
                ischar(S(1).subs{1}),
            B = obj.Hashtable.get(S(1).subs{1});
            if isempty(B),
                return;
            end
            mustBeClass = obj.Class.get(S(1).subs{1});            
            if ~isa(B, mustBeClass),
                switch mustBeClass
                    case {'single', 'double', 'char', 'cell'}
                         % Automatic conversion                      
                    otherwise
                         fieldNames = cell(obj.FieldNames.get(S(1).subs{1}));
                         B = cell2struct(cell(B), fieldNames);                        
                end  
                B = eval([mustBeClass '(B);']); 
            end
            return;
        end
        ME = MException('misc:hash:subsref:InvalidIndex', ...
            'Invalid index in indexed reference');
        throw(ME);
    otherwise
        ME = MException('misc:hash:subasgn:InvalidIndex', ...
            'Invalid indexing type %s in indexed reference', S(1).type);
        throw(ME);
   
    
    
end



end