function test = has_oge

[status, ~] = system('qstat');

test = isunix && ~status;

end