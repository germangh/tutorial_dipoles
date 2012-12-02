function str = fieldtrip(obj)
% FIELDTRIP
% Converts a sensors.eeg object to a Fieldtrip-compatible structure
%
% str = fieldtrip(obj)
%
% where
%
% OBJ is a sensors.eeg object
%
% STR is a struct that complies with Fieldtrip's standards
%
% See also: sensors.eeg


str = struct('pnt', obj.Cartesian, 'label', []);
str.label = obj.Label;


end