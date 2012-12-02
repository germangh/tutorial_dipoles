function y = isevent(obj)
% isevent - Returns true for event objects

y = isa(obj, 'PSET.event');