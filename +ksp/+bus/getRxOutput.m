function [kspRxOut,vesselRx,flight] = getRxOutput()
%GETRXOUTPUT Get kRPC Rx output bus.
%   [KSPRXOUT,VESSELRX,FLIGHT] = KSP.BUS.GETRXOUTPUT() returns the bus
%   output for the kRPC Rx block.
%
%   % EXAMPLE:
%       [kspRxOut,vesselRx,flight] = ksp.bus.getRxOutput()

% vessel bus

elems = Simulink.BusElement;

elems(1).Name = 'liquidFuelAmt';
elems(1).DataType = 'double';
elems(1).Description = 'Amount of liquid fuel remaining';

vesselRx = Simulink.Bus;
vesselRx.Elements = elems;
vesselRx.Description = 'received vessel data';

clear elems;

% flight bus

elems = Simulink.BusElement;

elems(1).Name = 'meanAltitude';
elems(1).DataType = 'double';
elems(1).Description = ['The altitude above sea level, in meters. '     ...
    'Measured from the center of mass of the vessel.'];

elems(2).Name = 'surfaceAltitude';
elems(2).DataType = 'double';
elems(2).Description = ['The altitude above the surface of the body or' ...
' sea level, whichever is closer, in meters. Measured from the center ' ...
'of mass of the vessel.'];

elems(3).Name = 'latitude';
elems(3).DataType = 'double';
elems(3).Description = ['The latitude of the vessel for the body being '...
'orbited, in degrees.'];

elems(4).Name = 'longitude';
elems(4).DataType = 'double';
elems(4).Description = ['The longitude of the vessel for the body being '...
'orbited, in degrees.'];

flight = Simulink.Bus;
flight.Elements = elems;
flight.Description = 'received flight data';

clear elems;

% kspRxOut bus

elems = Simulink.BusElement;

elems(1).Name = 'vessel';
elems(1).DataType = 'vesselRx';
elems(1).Description = 'received vessel data';

elems(2).Name = 'flight';
elems(2).DataType = 'flight';
elems(2).Description = 'received flight data';

kspRxOut = Simulink.Bus;
kspRxOut.Elements = elems;
kspRxOut.Description = 'data received from KSP';

end % getTxInput
