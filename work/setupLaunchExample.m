% setupLaunchExample

% get buses
[kspTxIn,control,autopilot] = ksp.bus.getTxInput();
mcout = ksp.bus.getModeCtrl();

% create struct for bus init
kspTxIn0 = Simulink.Bus.createMATLABStruct('kspTxIn');