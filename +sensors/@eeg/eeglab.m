function str = eeglab(obj)
% EEGLAB
% Converts a sensors.eeg object to an EEGLAB-compatible structure
%
% str = eeglab(obj)
%
% where
%
% OBJ is a sensors.eeg object
%
% STR is a struct array with sensor locations and labels, that complies 
% with EEGLAB's standards
%
% 
% See also: sensors.eeg

str = sensors.eeg.cart2eeglab(obj.Cartesian);
if ~isempty(obj.Label),
    for i = 1:length(str)
        str(i).Label = obj.Label{i};
    end
end

end