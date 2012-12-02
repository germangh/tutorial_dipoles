function obj = inverse_solution(obj, varargin)
import misc.process_varargin;

keySet = {'time', 'method'};

time = 1;
method='mne';
eval(process_varargin(keySet, varargin));

switch lower(method),
    case 'mne'
        M = pinv(obj.SourceDipolesLeadField);
        
        potentials = sum(source_leadfield(obj, 1:obj.NbSources, 'time', time),2);
        
        strength = M*potentials;
       
    otherwise
        
end

name = method;
pnt = 1:obj.NbSourceVoxels;
obj.InverseSolution = struct('name', name,...
    'strength', strength, ...
    'orientation', zeros(obj.NbSourceVoxels,3), ...
    'angle', zeros(obj.NbSources,1), ...
    'pnt', pnt, ...
    'momemtum', zeros(obj.NbSourceVoxels,3), ...
    'activation', ones(obj.NbSourceVoxels,1));


end