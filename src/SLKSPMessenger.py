import krpc

class SLKSPMessenger:
    """Forwards requests to krpc."""

    # krpc.client.Client object
    conn = -1
    # Vessel object
    vessel = -1
    # Flight object
    flight_info = -1
    # The ref. frame that is fixed relative to the celestial body.
    cb_frame = -1

    def __init__(self):
        self.conn = krpc.connect()
        self.vessel = self.conn.space_center.active_vessel
        self.flight_info = self.vessel.flight()
        self.cb_frame = self.vessel.orbit.body.reference_frame

    # getters

    def get_mean_altitude(self):
        """
        Get the altitude above sea level, in meters. Measured from the
        center of mass of the vessel.
        """
        return self.flight_info.mean_altitude

    def get_surface_altitude(self):
        """
        Get the altitude above the surface of the body or sea level,
        whichever is closer, in meters. Measured from the center of mass
        of the vessel.
        """
        return self.flight_info.surface_altitude

    def get_lat(self):
        """
        Get the latitude of the vessel for the body being orbited, in
        degrees.
        """
        return self.flight_info.latitude

    def get_lon(self):
        """
        Get the longitude of the vessel for the body being orbited, in degrees.
        """
        return self.flight_info.longitude

    def get_vel(self):
        """Get vessel's velocity vector (m/s) in the surface frame."""
        return self.vessel.flight(self.cb_frame).velocity

    def get_solid_fuel(self):
        """Get amount of solid fuel remaining."""
        return self.vessel.resources.amount('SolidFuel')

    def get_liquid_fuel(self):
        """Get amount of liquid fuel remaining."""
        return self.vessel.resources.amount('LiquidFuel')

    def get_met(self):
        """Get mission elapsed time (sec.)."""
        return self.vessel.met

    # setters

    def set_pitch_and_heading(self,pitch,heading):
        """
        Set autopilot target pitch, heading.
        pitch – Target pitch angle, in degrees between -90 and +90 deg.
        heading – Target heading angle, in degrees between 0 and 360 deg.
        """
        self.vessel.auto_pilot.target_pitch_and_heading(pitch,heading)

    def set_throttle(self,t):
        """
        Set the state of the throttle (a value between 0 and 1).
        """
        self.vessel.control.throttle = t

    def engage_autopilot(self):
        """Engage autopilot."""
        self.vessel.auto_pilot.engage()

    def activate_next_stage(self):
        """Activate next stage."""
        self.vessel.control.activate_next_stage()
