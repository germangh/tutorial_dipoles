function msg = eta(tinit,nbmcruns,i, varargin)
% ETA Displays the estimated time that is left to finnish the simulation.
%
% eta(t0, nbruns, i)
%
% Where
%
% t0 is the time at which the simulation started
%
% nbrun are the number of runs
%
% i is the current run index
%
%
% #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  #
% # The misc package for MATLAB                                           #
% # German Gomez-Herrero <german.gomezherrero@ieee.org>                   #
% # Netherlands Institute for Neuroscience                                #
% # Amsterdam, The Netherlands                                            #
% #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  #
%
% See also: misc

import misc.process_arguments;

opt.remaintime = false;

[~, opt] = process_arguments(opt, varargin);

persistent prevmsg;

ttoc = toc(tinit);
tdiff = (ttoc/i)*(nbmcruns-i);
ndays = floor(tdiff/(3600*24));
tdiff = tdiff - ndays*(3600*24);
nhours = floor(tdiff/(3600));
tdiff = tdiff - nhours*3600;
nmins = floor(tdiff/(60));
tdiff = tdiff - nmins*60;
nsecs = round(tdiff);

if opt.remaintime,
    if ndays > 0,
        timeleft = sprintf('%dd %dh %dm %ds', ndays, nhours, nmins, nsecs);
    elseif nhours > 0,
        timeleft = sprintf('%dh %dm %ds', nhours, nmins, nsecs);
    elseif nmins > 0,
        timeleft = sprintf('%dm %ds', nmins, nsecs);
    elseif nsecs > 0
        timeleft = sprintf('%ds', nsecs);
    else
        timeleft = '0s';
    end
    msg = sprintf('%2.0f%%%% (%s remaining)', round(i/nbmcruns*100), timeleft);
else
    msg = sprintf('%2.0f%%%%', round(i/nbmcruns*100));
end
if i > 1 && exist('prevmsg', 'var') && numel(prevmsg) > 1,
    fprintf(repmat('\b', 1, numel(sprintf(prevmsg))));
end
fprintf(msg);

if i == nbmcruns,
    prevmsg = '';
else
    prevmsg = msg;
end
pause(.01);


