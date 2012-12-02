classdef eeg
    % SENSORS.EEG
    % EEG sensor set
    %
    % Construction:
    %
    % obj = sensors.eeg;
    % obj = sensors.eeg('Cartesian', coord);
    % obj = sensors.eeg(str);
    %
    % where
    %
    % OBJ is a sensors.eeg object
    %
    % COORD is a Nx3 matrix with Cartesian coordinates for N sensors
    %
    % STR is an EEGLAB or Fieldtrip structure with sensor specifications
    %
    %
    % Public Interface Synopsis:
    %
    % str = eeglab(obj)     % Convert to EEGLAB format
    %
    % str = fieldtrip(obj)  % Convert to Fieldtrip format
    %
    % obj = read(obj, 'sensors.sfp'); % Read locations from file
    %
    % obj = map2surf(obj, surface);   % Map sensors onto a surface
    %
    %
    % See also: sensors
    
    properties (SetAccess = 'private')
        Label;
        Cartesian;
    end
    
    properties (Dependent = true)
        Spherical;
        Polar;
        NbSensors;
    end
    
    % Public interface
    methods
        obj = read(obj, filename);
        struct = eeglab(obj);
        struct = fieldtrip(obj);
        h = plot(obj);
    end
    
    % Dependent methods
    methods
        function value = get.NbSensors(obj)
            value = size(obj.Cartesian, 1);
        end
        
        function value = get.Spherical(obj)
            if isempty(obj),
                value = [];
            else
                [a, b, c] = cart2sph(obj.Cartesian(:,1), ...
                    obj.Cartesian(:,2), obj.Cartesian(:,3));
                value = [a b c];
            end
        end
        
        function value = get.Polar(obj)
            if isempty(obj),
                value = [];
            else
                [a, b, c] = cart2pol(obj.Cartesian(:,1), ...
                    obj.Cartesian(:,2), obj.Cartesian(:,3));
                value = [a b c];
            end
        end
        
    end
    
    % Constructor
    methods
        function obj = eeg(varargin)
            if nargin < 1, return; end
            
            import misc.process_varargin;
            
            keySet = {'cartesian', 'spherical', 'polar', 'label'};
            label        = [];
            cartesian    = [];
            spherical    = [];
            polar        = [];
            
            eval(process_varargin(keySet, varargin));
            
            if isempty(cartesian),
                if isempty(spherical),
                    if isempty(polar),
                        ME = MException('sensors:eeg:MissingArguments', ...
                            'Sensor coordinates must be provided');
                        throw(ME);
                    elseif ~isnumeric(polar) || size(polar, 2) ~= 3,
                        
                    else
                        obj.Cartesian = pol2cart(polar(:,1), polar(:,2), polar(:,3));
                    end
                elseif ~isnumeric(spherical) || size(spherical,2)~=3,
                    ME = MException('sensors:eeg:InvalidArguments', ...
                        'Invalid sensor coordinates');
                    throw(ME);
                else
                    if ~isempty(polar),
                        warning('sensors:eeg:AmbiguousArguments', ...
                            ['Multiple coordinates were provided: ' ...
                            'using the provided cartesian coordinates']);
                    end
                    obj.Cartesian = sph2cart(spherical(:,1), spherical(:,2), spherical(:,3));
                end
            else
                if ~isempty(spherical) || ~isempty(polar),
                    warning('sensors:eeg:AmbiguousArguments', ...
                        ['Multiple coordinates were provided: ' ...
                        'using the provided cartesian coordinates']);
                end
                obj.Cartesian = cartesian;
            end
            
            if ~isempty(label),
                obj.Label = label;
            else
                tmp = num2str((1:obj.NbSensors)');
                obj.Label = mat2cell(tmp, ones(obj.NbSensors,1), size(tmp,2));
            end
            
            % Global consistency check
            obj = check(obj);
            
            
        end
        
    end
    
    % Consistency checks
    methods
        function obj = set.Cartesian(obj, value)
            InvalidCoordinates =  ...
                MException('sensors:eeg:InvalidCoordinates', ...
                'Invalid sensor coordinates');
            if (~isnumeric(value) || any(value(:)>=Inf) || ...
                    any(value(:)<=-Inf)) ...
                    || (~isempty(value) && size(value,2)~=3),
                throw(InvalidCoordinates);
            end
            obj.Cartesian = value;
        end
        function obj = set.Label(obj, value)
            if ischar(value),
                value = {value};
            end
            if ~iscell(value),
                ME = MException('sensors:eeg:invalidLabel', ...
                    'Voxel labels must be a cell array of strings');
                throw(ME);
            end
            obj.Label = value;
        end
    end
    
    methods (Access=private)
        function obj = check(obj)
            if ~isempty(obj.Label) && length(obj.Label) ~= obj.NbSensors,
                warning('sensors:eeg:invalidLabel', ...
                    ['The number of sensor labels does not match the ' ...
                    'number of sensors: labels will be ignored']);
                obj.Label = [];
            end
        end
    end
    
    % Static helper methods
    methods (Static)
        y = cart2eeglab(cart_coordinates);
    end
    
    
    
end