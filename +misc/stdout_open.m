function stdoutOut = stdout_open(stdoutIn)

if nargin < 1 || isempty(stdoutIn),
    stdoutOut = 1;
    return;
end

if ischar(stdoutIn),
    [path, name, ext] = fileparts(stdoutIn);
    if isempty(path),
        path = session.instance.Folder;
    end
    stdoutOut = fopen([path filesep name ext], 'w');
else
    stdoutOut = stdoutIn;
end

end