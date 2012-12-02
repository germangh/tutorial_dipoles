function y = cart2eeglab(x)

MissingEEGLAB = MException('sensors:eeg:cart2eeglab', ...
    ['The EEGLAB toolbox is required \n', ...
    'You can get EEGLAB from: http://sccn.ucsd.edu/eeglab/']);

% Ensure that EEGLAB is in the path
if ~exist('readlocs', 'file'), 
    throw(MissingEEGLAB);
end

tmpfilename = [tempname '.xyz'];
dlmwrite(tmpfilename,[(1:size(x,1))' x (1:size(x,1))'],' ');

y = readlocs(tmpfilename, 'filetype', 'xyz');
y = y(:);

delete(tmpfilename);