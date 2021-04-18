function mcout = getModeCtrl()
%GETMODE Get mode control output bus.
%   MCOUT = KDSP.BUS.GETMODECTRL returns mode control output bus MCOUT.
%
%   % EXAMPLE:
%       mcout = ksp.bus.getModeCtrl()

elems = Simulink.BusElement;

elems(1).Name = 'mode';
elems(1).DataType = 'int16';
elems(1).Description = 'guidance system mode';

elems(2).Name = 'activateNextStage';
elems(2).DataType = 'boolean';
elems(2).Description = 'flag indicating stage activation';

mcout = Simulink.Bus;
mcout.Elements = elems;
mcout.Description = 'mode control signals';

end