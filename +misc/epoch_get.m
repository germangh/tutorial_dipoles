function [data, ev_out] = epoch_get(x, ev, varargin)
% epoch_get - Extracts epochs from a data matrix
%
%   DATA = epoch_get(DATA, EV), where DATA is of numeric type and EV is an
%   array of event objects, returns either a cell array or a numeric array
%   with the data epochs corresponding to the given events. 
%
%   DATA = epoch_get(OBJ, EV, 'Duration', DUR, 'Offset', OFFSET) extracts
%   epochs identified by the position of the given events but with the
%   provided duration (DUR) and offset (OFFSET). 
%
%   DATA = epoch_get(OBJ, POS, 'Duration', DUR, 'Offset', OFFSET) where POS
%   is a numeric array with the locations of the epochs.
%
%   [DATA, EV_OUT] = epoch_get(OBJ, EV) where EV_OUT is the array of
%   events that were used to extract the data in matrix/cell DATA. EV_OUT
%   might be different to EV if some of the events in EV are out of the
%   range of the input data.
%
% See also: PSET/pset, PSET/event, misc/epoch_set

import misc.process_varargin;
import misc.isevent;

THIS_OPTIONS = {'duration', 'offset', 'dims', 'baselinecorrection'};

if nargin < 1 || isempty(x) || ~isnumeric(x),
    error('misc:get_epoch:invalidInput', ...
        'First input argument must be a non-empty numeric array or pset object.');
end

if mod(nargin, 2),
    error('misc:get_epoch:invalidInput', ...
        'An even number of input arguments is expected.');
end

if nargin < 2 || length(ev)<1,
    data = [];
    ev_out = [];
    return;
end

% Default optional parameters
duration = [];
offset = [];
dims = [];
baselinecorrection = false;

% Process optional input arguments
eval(process_varargin(THIS_OPTIONS, varargin));

% Positions of the epochs fiducial points
if isevent(ev),
    pos = nan(numel(ev),1);
    for i = 1:numel(ev)
        pos(i) = ev(i).Sample;
    end
elseif isnumeric(ev),
    pos = ev;
end

n_pos = numel(pos);

% Durations of the epochs
if isempty(duration),
    if isevent(ev),
        dur = nan(numel(ev),1);
        for i = 1:numel(ev)
            dur(i) = ev(i).Duration;             
        end        
    else
        error('misc:get_epoch:missingDuration', ...
            'The duration of the epochs must be provided.');        
    end
else
    dur = repmat(duration, numel(ev), 1);
end

% Offset of the epochs
if isempty(offset),
    if isevent(ev),
        off = nan(numel(ev),1);
        for i = 1:numel(ev)
            off(i) = ev(i).Offset;             
        end        
    else        
        warning('misc:get_epoch:missingOffset', ...
            'Zero offset will be assumed for all epochs.'); 
        off = zeros(n_pos, 1);
    end
else
    off = repmat(offset, numel(ev),1);
end

% Check if epochs have different channel selections
diffdims = false;
if ~isempty(dims),
    if iscell(dims),
        n_dim = numel(dims{1});
        for j = 2:numel(dims)
            if numel(dims{j}) ~= n_dim || ~all(dims{j}==dims{j-1}),
                diffdims = true;
                break;
            end
        end
        
    end
else
    dims = 1:size(x,1);
end

if ~diffdims && iscell(dims),
    dims = dims{1};
end

if ~diffdims,
    dims = sort(dims(:), 'ascend');
end

% Extract the epochs
udur = unique(dur);
uoff = unique(off);

if length(uoff) > 1 || length(udur) > 1 || iscell(dims),
    outofrange = false(n_pos,1);
    data = cell(n_pos, 1);
    if iscell(dims),
        e_count = 0; % count of epochs in range
        for i = 1:n_pos 
            if pos(i)+off(i) > 1 && (pos(i)+off(i)+dur(i)-1) < size(x,2),
                e_count = e_count + 1;
                data{e_count} = x(dims{i}, pos(i)+off(i):pos(i)+off(i)+dur(i)-1);
            else
                outofrange(i) = true;
            end
        end        
    else
        e_count = 0; % count of epochs in range
        for i = 1:n_pos
            if pos(i)+off(i) > 1 && (pos(i)+off(i)+dur(i)-1) < size(x,2),
                e_count = e_count + 1;                
                data{e_count} = x(dims, pos(i)+off(i):pos(i)+off(i)+dur(i)-1);
            else
                outofrange(i) = true;
            end
        end
    end
    % Remove empty epochs (because they were out of range)
    data(e_count+1:end)=[];
else    
    % Remove epochs out of range
    outofrange = (pos + uoff) < 1 | (pos+uoff+udur-1) > size(x,2);
    pos(outofrange) = [];
    n_pos = length(pos);
    idx = repmat(pos,1,udur) + repmat(uoff:(uoff+udur-1), n_pos, 1);    
    idx = idx';    
    data = reshape(x(dims, idx(:)), numel(dims), udur, n_pos);
    if baselinecorrection && uoff < 0,
        idx_baseline = repmat(pos, 1, abs(uoff)) +  repmat(uoff:-1, n_pos, 1); 
        idx_baseline = idx_baseline';
        data_baseline = reshape(x(dims, idx_baseline(:)), numel(dims), abs(uoff), n_pos);
        data_baseline = repmat(mean(data_baseline,2), [1 udur 1]);
        data = data - data_baseline;
    end
end

ev_out = ev(~outofrange);


end
