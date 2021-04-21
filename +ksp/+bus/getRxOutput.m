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

elems(2).Name = 'solidFuelAmt';
elems(2).DataType = 'double';
elems(2).Description = 'Amount of solid fuel remaining';

elems(3).Name = 'met';
elems(3).DataType = 'double';
elems(3).Description = 'mission elapsed time (s)';

elems(3).Name = 'met';
elems(3).DataType = 'double';
elems(3).Description = 'mission elapsed time (s)';

elems(4).Name = 'apoapsisAltitude';
elems(4).DataType = 'double';
elems(4).Description = ['The apoapsis of the orbit, in meters, above '  ...
    'the sea level of the body being orbited.'];

elems(5).Name = 'periapsisAltitude';
elems(5).DataType = 'double';
elems(5).Description = ['The periapsis of the orbit, in meters, above '  ...
    'the sea level of the body being orbited.'];

elems(6).Name = 'timeToApoapsis';
elems(6).DataType = 'double';
elems(6).Description = 'Time to apoapsis (s).';

elems(7).Name = 'timeToPeriapsis';
elems(7).DataType = 'double';
elems(7).Description = 'Time to periapsis (s).';

elems(8).Name = 'eccentricity';
elems(8).DataType = 'double';
elems(8).Description = 'The eccentricity of the orbit.';

elems(9).Name = 'inclination';
elems(9).DataType = 'double';
elems(9).Description = 'The inclination of the orbit.';

elems(10).Name = 'orbitalSpeed';
elems(10).DataType = 'double';
elems(10).Description = 'Orbital speed (m/s).';

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

elems(5).Name = 'velocity';
elems(5).DataType = 'double';
elems(5).Dimensions = 3;
elems(5).Description = ['Vessel velocity (m/s) in reference frame ' ...
    'vessel.orbit.body.reference_frame'];

elems(6).Name = 'pitch';
elems(6).DataType = 'double';
elems(6).Dimensions = 1;
elems(6).Description = ['The pitch of the vessel relative to the '  ...
    'horizon, in degrees. A value between -90 and +90.'];

elems(7).Name = 'heading';
elems(7).DataType = 'double';
elems(7).Dimensions = 1;
elems(7).Description = ['The heading of the vessel (its angle '     ...
    'relative to north), in degrees. A value between 0 and 360.'];

elems(8).Name = 'gForce';
elems(8).DataType = 'double';
elems(8).Dimensions = 1;
elems(8).Description = 'The current G force acting on the vessel in g.';

elems(9).Name = 'horizontalSpeed';
elems(9).DataType = 'double';
elems(9).Dimensions = 1;
elems(9).Description = 'Vessel horizontal speed (m/s) in the surface frame.';

elems(10).Name = 'verticalSpeed';
elems(10).DataType = 'double';
elems(10).Dimensions = 1;
elems(10).Description = 'Vessel vertical speed (m/s) in the surface frame.';

% to be continued ...

% see
% https://krpc.github.io/krpc/python/api/space-center/flight.html

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
