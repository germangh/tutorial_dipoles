function h = plot(obj, varargin)
% PLOT
% Plots a head model
%
% plot(obj)
%
% plot(obj, 'key', value, ...)
%
%
% where
%
% OBJ is a head.mri object
%
% 
% Accepted key/value pairs:
%
% 'Surface'     : A cell array with the names of the surfaces that should
%                 be plotted. Valid surface names are 'OuterSkin', 
%                 'OuterSkinDense', 'OuterSkull', 'OuterSkullDense', 
%                 'InnerSkull', 'InnerSkullDense'. 
%                 Default: {'OuterSkin', 'InnerSkull'};
%
% 'Sensors'     : A boolean scalar that specifies whether or not to plot
%                 the sensor locations. Default: true
%
% 'SourceSpace' : A boolean scalar that specifies whether or not to plot
%                 the source grid locations. Note that this argument is
%                 only relevant if a source space has been built, e.g.
%                 using make_source_grid(). Default: false
%
% 
% Example:
% To plot only the inner skull surface use:
%
% plot(obj, 'surface', {'InnerSkull'}, 'sensors', false)
%
%
%
% See also: head.mri

% Documentation: class_head_mri.txt
% Description: Plots an anatomical head model

import misc.process_varargin;
import misc.plot_mesh;


SURF_COLOR.OUTERSKIN        = [.3 .3 .3];
SURF_COLOR.OUTERSKINDENSE   = [.7 .7 .7];
SURF_COLOR.INNERSKULL       = [1 0 0];
SURF_COLOR.INNERSKULLDENSE  = [.5 0 0];
SURF_COLOR.OUTERSKULL       = [0 1 0];
SURF_COLOR.OUTERSKULLDENSE  = [0 .5 0];
SIZE_DATA = 50;
SIZE_DATA_GRID = 30; %#ok<*NASGU>
GRID_COLOR='k';

keySet      = {'surface', 'sensors', 'sourcespace'};
surface     = {'OuterSkin', 'InnerSkull'};
sensors     = true;
sourcespace = false;

eval(process_varargin(keySet, varargin));

h = [];

if ischar(surface), surface = {surface}; end

if numel(surface) == 1 && strcmpi(surface{1},'none'),
    surface = [];
end

for surfIter = surface
    thisSurf = surfIter{1};
    thisH = plot_mesh(obj.(thisSurf).pnt, ...
        obj.(thisSurf).tri, 'facecolor', SURF_COLOR.(upper(thisSurf)));
    h = [h thisH]; %#ok<*AGROW>
    hold on;
end

if sensors,
    thisH = plot(obj.Sensors);
    set(thisH, 'SizeData', SIZE_DATA);
    h = [h thisH];
end

if (~islogical(sourcespace) || sourcespace) && ~isempty(obj.SourceSpace),
    if ~islogical(sourcespace),
        index = sourcespace;
    else
        index = 1:size(obj.SourceSpace.pnt,1);
    end
    thisH = scatter3(obj.SourceSpace.pnt(index, 1), ...
        obj.SourceSpace.pnt(index, 2), ...
        obj.SourceSpace.pnt(index, 3), GRID_COLOR, 'o', 'filled'); %#ok<*UNRCH>
    set(thisH, 'SizeData', SIZE_DATA_GRID);
    h = [h thisH];
    axis equal;
    set(gca, 'visible', 'off');
    set(gcf, 'color', 'white');
end






end