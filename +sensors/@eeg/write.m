function obj = write(obj, filename)
% WRITE
% Writes EEG sensors information to a file
%
% obj = write(obj, filename)
%
% where
%
% OBJ is a eeg.sensors object
%
% FILENAME is a full path name (with file extension .hpts or .sfp)
%
%
% See also: sensors.eeg


[~, ~, ext] = fileparts(filename);

InvalidFormat = MException('sensors:eeg:read:InvalidFormat', ...
    'Format %s is not supported', ext);

switch lower(ext)
    case '.sfp',
        throw(InvalidFormat);

    case '.hpts', 
        io.hpts.write(filename, obj.Cartesian, 'id', obj.Label, ...
            'category', 'eeg'); 

        
    otherwise
        throw(InvalidFormat);
    
end

end