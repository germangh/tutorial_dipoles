function obj = subsasgn(obj, S, B)
% SUBSASGN Subscripted assignment for class @hash
%


switch S(1).type
    case '()',         
        if numel(S(1).subs) == 1 && iscell(S(1).subs) && ...
                ischar(S(1).subs{1}),
            obj.Class.put(S(1).subs{1}, class(B));     
            switch class(B),
                case {'single', 'double', 'char', 'cell'}
                    % No conversion necessary                                     
                otherwise
                    warning('off', 'MATLAB:structOnObject');
                    B = struct(B);
                    obj.FieldNames.put(S(1).subs{1}, fieldnames(B));
                    B = struct2cell(B);                              
            end
            if isempty(B), return; end
            obj.Hashtable.put(S(1).subs{1}, B);
            
            return;
        end
        ME = MException('misc:hash:subasgn:InvalidIndex', ...
            'Invalid index in indexed assignment');
        throw(ME);
        
    otherwise,
        ME = MException('misc:hash:subasgn:InvalidIndex', ...
            'Invalid indexing type %s in indexed assignment', S(1).type);
        throw(ME);
            
end



end