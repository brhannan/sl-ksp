import krpc

class Receive:
    conn = -1
    vessel = -1
    flight_info = -1
    # altitude_stream = -1
    srf_frame = -1

    def __init__(self):
        self.conn = krpc.connect()
        self.vessel = self.conn.space_center.active_vessel
        self.flight_info = self.vessel.flight()
        self.srf_frame = self.vessel.orbit.body.reference_frame

    # getters

    def get_mean_altitude(self):
        '''
        Get the altitude above sea level, in meters. Measured from the
        center of mass of the vessel.
        '''
        return self.flight_info.mean_altitude

    def get_surface_altitude(self):
        '''
        Get the altitude above the surface of the body or sea level,
        whichever is closer, in meters. Measured from the center of mass
        of the vessel.
        '''
        return self.flight_info.surface_altitude

    def get_lat(self):
        '''
        Get the latitude of the vessel for the body being orbited, in
        degrees.
        '''
        return self.flight_info.latitude

    def get_lon(self):
        '''
        Get the longitude of the vessel for the body being orbited, in
        degrees.
        '''
        return self.flight_info.longitude

    def get_vel(self):
        '''
        Get vessel's velocity vector (m/s) in the surface frame.
        '''
        # return self.flight_info.velocity
        return self.vessel.flight(self.srf_frame).velocity

    # def get_speed(self):
    #     '''
    #     Get the speed of the vessel in meters per second, in the reference
    #     frame ReferenceFrame.
    #     '''
    #     return self.flight_info.speed

    def get_solid_fuel(self):
        '''
        Get amount of solid fuel remaining.
        '''
        return self.vessel.resources.amount('SolidFuel')

    def get_liquid_fuel(self):
        '''
        Get amount of liquid fuel remaining.
        '''
        return self.vessel.resources.amount('LiquidFuel')

    def get_met(self):
        '''
        Get mission elapsed time (sec.).
        '''
        return self.vessel.met

    # def get_mean_altitude_stream(self):
    #     '''
    #     get mean altitude (m)
    #     '''
    #     # alt = self.altitude_stream()
    #     # return alt
    #     return self.flight_info.mean_altitude

    # setup

    # def set_up_altitude_stream(self):
    #     '''
    #     create telem stream for mean altitude
    #     '''
    #     self.altitude_stream = self.conn.add_stream(getattr,
    #       self.vessel.flight(), 'mean_altitude')
