function kspRxOut = getRxOutput()
%GETRXOUTPUT Get kRPC Rx output bus.
%   KSPRXOUT = KSP.BUS.GETRXOUTPUT() returns the bus output for the kRPC Rx
%   block.
%   
%   % EXAMPLE:
%       kspRxOut = ksp.bus.getRxOutput()

elems = Simulink.BusElement;

elems(1).Name = 'liquidFuelAmt';
elems(1).DataType = 'double';
elems(1).Description = 'Amount of liquid fuel remaining';


kspRxOut = Simulink.Bus;
kspRxOut.Elements = elems;
kspRxOut.Description = 'data from KSP';

end % getTxInput