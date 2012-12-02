function obj = read(~, filename)
% READ
% Reads EEG sensors information from a file
%
% obj = read(obj, filename)
%
% where
%
% OBJ is a eeg.sensors object
%
% FILENAME is the full path to a .sfp or .hpts file with sensor locations
%
%
% See also: sensors.eeg


[~, ~, ext] = fileparts(filename);

InvalidFormat = MException('sensors:eeg:read:InvalidFormat', ...
    'Format %s is not supported', ext);

switch lower(ext)
    case '.sfp',
        [xyz, id] = io.sfp.read(filename);     

    case '.hpts', 
        [xyz, cat, id] = io.hpts.read(filename);
        xyz = xyz(~ismember(cat, 'cardinal'), :);
        id = id(~ismember(cat, 'cardinal'));

        
    otherwise
        throw(InvalidFormat);
    
end

obj = sensors.eeg('Cartesian', xyz, 'label', id);

end