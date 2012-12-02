function obj = make_bem(obj, varargin)
import misc.process_varargin;
import external.fieldtrip.ft_prepare_bemmodel;

keySet = {'method'};
method = 'bemcp';
eval(process_varargin(keySet, varargin));

% Generate the BEM model
volume.source = 1;
volume.skin   = 3;
volume.bnd(1) = obj.InnerSkull;
volume.bnd(2) = obj.OuterSkull;
volume.bnd(3) = obj.OuterSkin;
cfg.method = method;
obj.FieldTripVolume = ft_prepare_bemmodel(cfg, volume);




end