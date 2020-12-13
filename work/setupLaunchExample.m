% setupLaunchExample

% get buses
[kspTxIn,control,autopilot] = ksp.bus.getTxInput();
[kspRxOut,vesselRx,flight] = ksp.bus.getRxOutput();
mcout = ksp.bus.getModeCtrl();

% create struct for bus init
kspTxIn0 = Simulink.Bus.createMATLABStruct('kspTxIn');
