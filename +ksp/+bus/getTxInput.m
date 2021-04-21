function [kspTxIn,control,autopilot] = getTxInput()
%GETTXINPUT Get kRPC Tx input bus.
%   [kspTxIn,control,autopilot] = KSP.BUS.GETTXINPUT() returns the bus 
%   input to the kRPC TX block.
%   
%   % EXAMPLE:
%       [kspTxIn,control,autopilot] = ksp.bus.getTxInput()

% control bus
% https://krpc.github.io/krpc/python/api/space-center/control.html

elems = Simulink.BusElement;

elems(1).Name = 'sas';
elems(1).DataType = 'boolean';
elems(1).Description = 'SAS (stability assist system) state.';

elems(2).Name = 'throttle';
elems(2).DataType = 'double';
elems(2).Min = 0;
elems(2).Max = 1;
elems(2).Description = 'State of the throttle. A value between 0 and 1.';

elems(3).Name = 'activateNextStage';
elems(3).DataType = 'boolean';
elems(3).Description = 'activate next stage when true';

elems(4).Name = 'resetReferenceFrames';
elems(4).DataType = 'boolean';
elems(4).Description = 'Get current values for all ref. frames when true.';

control = Simulink.Bus;
control.Elements = elems;
control.Description = 'control data';


% autopilot bus
% krpc.github.io/krpc/python/api/space-center/auto-pilot.html

clear elems;
elems = Simulink.BusElement;

% --- to do: add method when high ---
elems(1).Name = 'engage';
elems(1).DataType = 'boolean';
elems(1).Description = 'engage autopilot';

elems(2).Name = 'targetPitch';
elems(2).DataType = 'double';
elems(2).Min = -90;
elems(2).Max = 90;
elems(2).Description = 'target pitch angle (deg)';

elems(3).Name = 'targetHeading';
elems(3).DataType = 'double';
elems(3).Min = 0;
elems(3).Max = 360;
elems(3).Description = 'target heading angle (deg)';

elems(4).Name = 'commandPrograde';
elems(4).DataType = 'boolean';
elems(4).Description = 'Command SAS to drive vessel to prograde.';

elems(5).Name = 'commandRetrograde';
elems(5).DataType = 'boolean';
elems(5).Description = 'Command SAS to drive vessel to retrograde.';

autopilot = Simulink.Bus;
autopilot.Elements = elems;
autopilot.Description = 'autopilot bus';


% kspTxIn bus
% This bus wraps the buses above into a single input to the ToKSP block.

clear elems;
elems = Simulink.BusElement;

elems(1).Name = 'control';
elems(1).DataType = 'control';
elems(1).Description = 'control data';

elems(2).Name = 'autopilot';
elems(2).DataType = 'autopilot';
elems(2).Description = 'autopilot data';

kspTxIn = Simulink.Bus;
kspTxIn.Elements = elems;
kspTxIn.Description = 'ToKSP input.';

end % getTxInput