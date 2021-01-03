import krpc

class KerbalRx:
    # kRPC connection
    conn = -1
    vessel = -1
    flight_info = -1
    # altitude_stream = -1

    def __init__(self):
        # set up connection and get active vessel
        # conn0 = krpc.connect()
        # vessel0 = conn0.space_center.active_vessel
        # self.conn = conn0
        # self.vessel = conn0.space_center.active_vessel
        conn = krpc.connect()
        self.conn = krpc.connect()
        self.vessel = conn.space_center.active_vessel
        # set up flight
        self.flight_info = self.vessel.flight()

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
        Get vessel's velocity vector (m/s).
        '''
        return self.flight_info.velocity

    def get_speed(self):
        '''
        Get the speed of the vessel in meters per second, in the reference
        frame ReferenceFrame.
        '''
        return self.flight_info.speed

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
    #     self.altitude_stream = self.conn.add_stream(getattr, self.vessel.flight(), 'mean_altitude')
