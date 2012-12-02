function [sensorNew, M, distProj] = map2surf(sensor, scalp, varargin)
% MAP2SURF
% Maps EEG sensors onto the scalp surface
%
% [sensorNew, M] = map2surf(sensor, scalp)
%
% [sensorNew, M] = map2surf(sensor, scalp, 'key', value)
%
% where
%
% SENSOR is a sensorCoord.eeg object
%
% SCALP is surface structure with a .pnt and .tri fields. Alternatively,
% SCALP can be a full path to a Freesurfer surface
% file in .tri format. If SCALP is a directory name, MAP2SURF will scan the
% directory and process all the .tri files that it contains
%
% SENSORNEW is an Nx3 matrix with the coordinates of the sensors after
% being projected onto the scalp surface
%
% M is the NxN projection matrix from the old sensorCoord coordinates to the new
% ones
%
% Optional arguments can be passed as key/value pairs:
%
% 'recursiveIcp'    :
%
%

import misc.process_arguments;
import misc.nn_all;
import misc.nn_radius;
import misc.rdir;
import misc.eta;
import misc.plot_mesh;
import io.hpts.write;
import external.icp.ICP_finite;

% Some constants
EDGE_ALPHA = 1;
FACE_ALPHA = 1;
EDGE_COLOR = [0 0 0];
FACE_COLOR = [.3 .3 .3];

% Optional input arguments
keySet      = {'reIcp', 'icpPoints', 'hpts', 'fig', 'label', 'verbose'};

reIcp       = false;
icpPoints   = 30;
hpts        = [];
fig         = true;
label       = 'sensors';
verbose     = true;
eval(process_arguments(keySet, varargin));

sensorCoord = sensor.Cartesian;

triFileName = 'map2surf';
if ischar(scalp) && isempty(findstr(scalp, '*')),
    [scalp, ~, ~, facesScalp] = read_file(scalp);
elseif ischar(scalp),
    % scalp if a folder -> call recursively
    files = rdir(scalp);
    for i = 1:numel(files)
        [path, name] = fileparts(files(i).name);
        fname = [path filesep name '_' label '.hpts'];
        [sensorNew, M, distProj] = ...
            map2surf(sensorCoord, files(i).name, varargin{:}, 'hpts', fname);
        if verbose,
            fprintf('%s -> %s\n', name, fname);
        end
    end
    return;
else
    facesScalp = scalp.tri;
    scalp = scalp.pnt;
end

% How close can two points be?
[~, radius] = nn_all(sensorCoord);
radius      = min(radius);

% First register the points
opt.Verbose = (verbose>1);
[sensorCoord, M] = ICP_finite(scalp, sensorCoord, opt);

% Project all points onto the surface starting from the closest pair
nSensors  = size(sensorCoord, 1);
nScalpVertices = size(scalp, 1);
sensorIdx   = 1:nSensors;
scalpIdx    = 1:nScalpVertices;
sensorNew   = nan(size(sensorCoord));
distProj    = nan(size(sensorCoord,1), 1);
if verbose && nSensors > 0,
    fprintf('(sensors:eeg:map2surf) Projecting %d sensors onto the skin surface...', nSensors);
end
tinit = tic;
runs  = nSensors;
count = 0;
while (nSensors > 0),
    [idxStatProj, dist] = nn_all(sensorCoord(sensorIdx,:), scalp(scalpIdx, :));
    % Project only the closest point
    [val, idx]                      = min(dist);
    idxStatProj                     = idxStatProj(idx);
    sensorNew(sensorIdx(idx), :)    = scalp(scalpIdx(idxStatProj), :);
    distProj(idx)                   = val;
    % Remove all points within a radius of the selected static point
    scalpIdx(nn_radius(scalp(scalpIdx(idxStatProj), :), scalp(scalpIdx, :), ...
        radius)) = [];
    % Remove the relevant dynamic point
    sensorIdx(idx) = [];
    nSensors  = nSensors - 1;
    count = count + 1;
    if verbose,
        misc.eta(tinit, runs, count);
    end
    if reIcp && nSensors > icpPoints,
        if verbose,
            fprintf('(sensors:eeg:map2surf) Running ICP on %d points...', icpPoints);
        end
        opt.Verbose      = verbose;
        sensorCoord(sensorIdx,:) = ICP_finite(scalp(scalpIdx,:), ...
            sensorCoord(sensorIdx,:), opt);
        if verbose,
            fprintf('\n');
        end
    end
end
if verbose && (runs <= icpPoints || ~reIcp),
    fprintf('\n');
end

sensorNew = sensors.eeg('Cartesian', sensorNew, 'label', sensor.Label);

if ~isempty(hpts),
    [~, ~, ext] = fileparts(hpts);
    if isempty(ext),
        hpts = [hpts '.hpts'];
    end
    hpts_write(hpts, sensorNew, 'category', cat_dyn, 'id', id_dyn);
end

if fig,
    tr = TriRep(facesScalp, scalp(:,1), scalp(:,2), scalp(:,3));
    h=trimesh(tr);
    set(h, ...
        'FaceColor', FACE_COLOR, ...
        'FaceAlpha', FACE_ALPHA, ...
        'EdgeColor', EDGE_COLOR', ...
        'EdgeAlpha', EDGE_ALPHA);
    
    hold on;
    
    scatter3(sensorNew.Cartesian(:,1), ...
        sensorNew.Cartesian(:,2), ...
        sensorNew.Cartesian(:,3), 'r', 'filled');
    
    axis equal;
    set(gca, 'visible', 'off');
    set(gcf, 'color', 'white');
    set(gcf, 'Name', triFileName);
end

end


function [sensorCoord, cat, id, faces] = read_file(sensorCoord)

faces = [];
% sensorCoord is a set of points in a .tri, .sfp or .hpts file
[~, ~, ext] = fileparts(sensorCoord);
cat = [];
id = [];
switch lower(ext)
    case '.tri',
        [sensorCoord, faces] = io.tri.read(sensorCoord);
    case '.sfp',
        sensorCoord = sfp_read(sensorCoord)*10; % must be in mm
    case '.hpts',
        [sensorCoord, cat, id] = io.hpts.read(sensorCoord);
    case {'.gz', '.nii'},
        sensorCoord = io.mango.read(sensorCoord);
    otherwise,
        ME = MException(me, 'File %s is of unknown type', sensorCoord);
        throw(ME);
end

end