function data_out = epoch_align(data, max_lag)
% epoch_align - Aligns a set of epochs
%
%   DATA_OUT = epoch_align(DATA_IN) where DATA_IN is a cell array or a
%   numeric array containing data epochs. DATA_OUT is a numeric array that
%   has an aligned epoch in each row.
%
% See also: misc/epoch_template

import misc.globals;
import misc.find_shift;

if nargin < 2, max_lag = []; end

if iscell(data),
    
    % Duration of each epoch
    dur = nan(length(data),1);
    for i = 1:length(data),
        dur(i) = size(data{i},2);
        if size(data{i},1) ~= size(data{i},1),
            error('misc:epoch_align:invalidDim', ...
                'Cannot align epochs with different dimensionality.');
        end
    end
    % The longest epoch will be used as reference
    [max_dur, idx_in] = max(dur);
    idx_out = setdiff(1:length(data), idx_in);
    template = data{idx_in};    
    
    % Update max_lag
    if isempty(max_lag),
        factor = 50/100;%globals.evaluate.MaxLag
        max_lag = round(factor*max_dur);
    end
    
    data_out = nan(size(template,1), size(template,2), length(data));
    
    % Build the template
    while ~isempty(idx_out)
        [ccoef, lag] = find_shift(template, data(idx_out), max_lag);
        [~, max_idx] = max(ccoef);
        % Remove the selected epoch from the pool of epochs       
        idx_in = union(idx_in, idx_out(max_idx));        
        first = lag(max_idx)+1;
        last = first+size(data{idx_out(max_idx)},2)-1;
        idx = intersect(first:last, 1:size(template,2));
        data_out(:, idx, idx_out(max_idx)) = data{idx_out(max_idx)}(:, idx-lag(max_idx));        
        % Update the template
        %template = nanmean(data_out(:,:,idx_in),3);
        %template(isnan(template)) = 0;
        idx_out(max_idx) = [];
    end
    
elseif isnumeric(data),
    error('Not implemented yet!');
else
    error('misc:epoch_align:invalidInput',...
        'The input argument must be a cell array or a numeric array.');
end

end

