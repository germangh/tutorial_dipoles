function obj = inverse_solution(obj, varargin)
% INVERSE_SOLUTION - Compute inverse solution
%
% obj = inverse_solution(obj);
%
% obj = inverse_solution(obj, 'key', value, ...);
%
% Where
%
% OBJ is a head.mri object.
%
% 
% See also: head.mri

% Documentation: class_head_mri.txt
% Description: Compute inverse solution

import misc.process_varargin;

keySet = {'time', 'method'};

time = 1;
method='mne';
eval(process_varargin(keySet, varargin));

switch lower(method),
    case 'mne'
        M = pinv(obj.SourceDipolesLeadField);
        
        potentials = scalp_potentials(obj, 'time', time);
        
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