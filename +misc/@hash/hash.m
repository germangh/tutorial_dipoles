classdef hash
    
    properties (GetAccess=private,SetAccess = private)
        Hashtable;
        Class;
        FieldNames;
    end
    
    % Constructor
    methods
        function obj = hash
            obj.Hashtable = java.util.Hashtable;
            obj.Class     = java.util.Hashtable;
            obj.FieldNames = java.util.Hashtable;
        end
    end
    
    % Public methods
    methods
        obj      = subsasgn(obj, S, B);
        value    = subsref(A, S);
        keysCell = keys(obj);
        disp(obj);
    end
    
    
   
    
    
    
end