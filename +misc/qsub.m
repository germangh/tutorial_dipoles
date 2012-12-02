function qsub(cmd, varargin)
% Runs a matlab command via OGE
import misc.process_arguments;
import misc.split;
import misc.join;
import misc.globals;

if isempty(cmd), return; end

if ~ischar(cmd),
    error('misc:qsub', 'A string is expected as input argument');
end

opt.hmemory     = globals.evaluate.HVmem;
opt.smemory     = [];
opt.walltime    = globals.evaluate.HRt;
opt.name        = 'misc.qsub';

[~, opt] = process_arguments(opt, varargin);

if isempty(opt.smemory),
    opt.smemory = floor(0.9*opt.hmemory);
end

% Create the m-file
mFile = tempname;
fid = fopen(mFile, 'w');
try
    pathCell = split(':', path);
    newPathCell = pathCell;
    for i = 1:numel(pathCell),
       if newPathCell{i}(1)~='/',
          newPathCell{i} = [pwd '/' newPathCell{i}]; 
       end
    end
    fprintf(fid, 'try\n');    
    fprintf(fid, ...
        ['addpath(''' join(''',...\n''', unique(newPathCell)) ''');\n']);
    if strcmp(cmd(end), ';'),
        cmd(end) = [];
    end
    fprintf(fid, [misc.join(';\n', misc.split(';',cmd)) ';']);
    fprintf(fid, '\nexit;\n');
    fprintf(fid, 'catch ME\n');
    fprintf(fid, 'fprintf(''%%s : %%s'', ME.identifier, ME.message);\n');
    fprintf(fid, 'exit;\n');
    fprintf(fid, 'end\n');
    fclose(fid);
catch ME
    fclose(fid);
    rethrow(ME);
end

% Create the shell script
shFile = tempname;
fid = fopen(shFile, 'w');
try
    fprintf(fid, '#!/bin/sh\n');
    fprintf(fid, ...
        sprintf('matlab -nodisplay -nosplash -singleCompThread < %s\n', mFile));
    fclose(fid);
catch ME
    fclose(fid);
    rethrow(ME);
end
system(sprintf('chmod a+x %s', shFile));

% Submit the job
qsubCmd = sprintf('qsub -N "%s" -l h_rt=%s -l s_vmem=%.0fG -l h_vmem=%.0fG < %s', ...    
    opt.name, ...
    opt.walltime, ...
    opt.smemory, ...
    opt.hmemory, ...
    shFile);
[status, res]=system(qsubCmd);
if status,
    ME = MException('misc:qsub:OGEError', ...
        'Something went wrong when submitting the job to OGE');
    throw(ME);
end
if numel(cmd) > 100,
    cmd = [cmd(1:100) '...'];
end
fprintf([res ' : ' cmd '\n']);

end