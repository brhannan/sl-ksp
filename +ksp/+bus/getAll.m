function getAll()
%KSP.BUS.GETALL Intialize all KSP input/ouptut buses in the base workspace.
%   KSP.BUS.GETALL creates the ToKSP input and FromKSP output bus objects
%   in the base workspace.
%
%   % EXAMPLE:
%       ksp.bus.getAll

%    Copyright 2020 Brian Hannan.

[kspRxOut,vesselRx,flight] = ksp.bus.getRxOutput();
[kspTxIn,control,autopilot] = ksp.bus.getTxInput();

assignin('base','kspRxOut',kspRxOut)
assignin('base','vesselRx',vesselRx)
assignin('base','flight',flight)

assignin('base','kspTxIn',kspTxIn)
assignin('base','control',control)
assignin('base','autopilot',autopilot)

end