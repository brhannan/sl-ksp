import krpc

class SLKSPMessenger:
    """Forwards requests to kRPC."""

    # krpc.client.Client object
    conn = -1
    # Vessel object
    vessel = -1
    # Flight object
    flight_info = -1

    # Celestial body frame
    #   The ref. frame that is fixed relative to the celestial body.
    #   (Vessel.orbit.body.reference_frame)
    celestial_body_frame = -1
    # Vessel frame.
    #   The reference frame that is fixed relative to the vessel and 
    #   orientated with the vessel. (Vessel.reference_frame)
    vessel_frame = -1
    # Orbital reference frame
    #   The reference frame that is fixed relative to the vessel, and 
    #   orientated with the vessels orbital prograde/normal/radial 
    #   diections. (Vesel.orbital_reference_frame)
    orbital_ref_frame = -1
    # Nonrotating refrence frame
    #   The reference frame that is fixed relative to this celestial body, 
    #   and orientated in a fixed direction (it does not rotate with the 
    #   body). (CelestialBody.non_rotating_reference_frame)
    non_rotating_ref_frame = -1

    def __init__(self):
        self.conn = krpc.connect(name='Simulink model')
        self.vessel = self.conn.space_center.active_vessel
        self.flight_info = self.vessel.flight()
        self.get_all_ref_frames()

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
        return self.vessel.flight(self.celestial_body_frame).velocity

    def get_horizontal_speed(self):
        """Get vessel's horizontal speed (m/s) in the surface frame."""
        return self.vessel.flight(self.celestial_body_frame).horizontal_speed

    def get_vertical_speed(self):
        """Get vessel's vertical speed (m/s) in the surface frame."""
        return self.vessel.flight(self.celestial_body_frame).vertical_speed

    def get_solid_fuel(self):
        """Get amount of solid fuel remaining."""
        return self.vessel.resources.amount('SolidFuel')

    def get_liquid_fuel(self):
        """Get amount of liquid fuel remaining."""
        return self.vessel.resources.amount('LiquidFuel')

    def get_met(self):
        """Get mission elapsed time (sec.)."""
        return self.vessel.met
    
    def get_pitch(self):
        """
        Get the pitch of the vessel relative to the horizon (degrees). 
        A value between -90 and +90 deg.
        """
        return self.flight_info.pitch

    def get_heading(self):
        """
        Get the heading of the vessel (its angle relative to north) 
        (degrees). A value between 0 and 360 deg.
        """
        return self.flight_info.heading

    def get_g_force(self):
        """
        Get the current G force acting on the vessel in g.
        """
        return self.flight_info.g_force

    def get_vehicle_apoapsis_altitude(self):
        """
        The apoapsis of the orbit, in meters, above the sea level of the 
        body being orbited.
        """
        return self.vessel.orbit.apoapsis_altitude

    def get_vehicle_periapsis_altitude(self):
        """
        The periapsis of the orbit, in meters, above the sea level of the 
        body being orbited.
        """
        return self.vessel.orbit.periapsis_altitude

    def get_time_to_apoapsis(self):
        """
        The time until the object reaches apoapsis, in seconds.
        """
        return self.vessel.orbit.time_to_apoapsis

    def get_time_to_periapsis(self):
        """
        The time until the object reaches periapsis, in seconds.
        """
        return self.vessel.orbit.time_to_periapsis

    def get_eccentricity(self):
        """The eccentricity of the orbit."""
        return self.vessel.orbit.eccentricity

    def get_inclination(self):
        """The inclination of the orbit (rad)."""
        return self.vessel.orbit.inclination

    def get_orbital_speed(self):
        """The current orbital speed (m/s)."""
        return self.vessel.orbit.orbital_speed

    # Reference frame helper functions.
    #   See:
    #   https://krpc.github.io/krpc/tutorials/reference-frames.html

    def get_all_ref_frames(self):
        """Get current values of all reference frames."""
        self.get_celestial_body_frame()
        self.get_vessel_frame()
        self.get_orbital_ref_frame()
        self.get_non_rotating_ref_frame()

    def get_celestial_body_frame(self):
        """
        Get current celestial body frame. The result is stored in property 
        celestial_body_frame.
        See:
        https://krpc.github.io/krpc/python/api/space-center/vessel.html
        """
        self.celestial_body_frame = self.vessel.orbit.body.reference_frame

    def get_vessel_frame(self):
        """
        Get Vesel.reference_frame. The result is stored in property 
        vessel_frame.
        See:
        https://krpc.github.io/krpc/python/api/space-center/vessel.html
        """
        self.vessel_frame = self.vessel.reference_frame

    def get_orbital_ref_frame(self):
        """
        Get Vesel.orbital_reference_frame. The result is stored in property 
        vessel_frame.
        See:
        https://krpc.github.io/krpc/python/api/space-center/vessel.html
        """
        self.orbital_ref_frame = self.vessel.reference_frame

    def get_non_rotating_ref_frame(self):
        """
        Get CelestialBody.non_rotating_ref_frame. The result is stored in 
        property non_rotating_ref_frame.
        See
        https://krpc.github.io/krpc/python/api/space-center/celestial-body.html
        """
        self.non_rotating_ref_frame = self.vessel.orbit.body.non_rotating_reference_frame


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

    def engage_sas(self):
        """Engage stability assist system."""
        self.vessel.control.sas = True;

    # TODO: method below has not been incorporated into SLKSPMessenger.
    def disengage_sas(self):
        """Engage stability assist system."""
        self.vessel.control.sas = True;

    def activate_next_stage(self):
        """Activate next stage."""
        self.vessel.control.activate_next_stage()

# The lines below are commented b/c prograde/retrograde not supported yet.

    def set_sas_mode_prograde(self):
        """
        Command SAS autopilot to drive vessel to prograde. See
        krpc.github.io/krpc/python/api/space-center/control.html#SpaceCenter.SASMode
        """
        try:
           self.vessel.control.sas_mode = self.vessel.control.sas_mode.prograde
        except krpc.client.RPCError:
           print('Could not set SAS Mode to prograde.')
           pass

#     def set_sas_mode_retrograde(self):
#         """
#         Command SAS autopilot to drive vessel to retrograde. See
#         krpc.github.io/krpc/python/api/space-center/control.html#SpaceCenter.SASMode
#         """
#         try:
#            self.vessel.control.sas_mode = self.vessel.control.sas_mode.retrograde
#         except krpc.client.RPCError:
#            print('Could not set SAS Mode to retrograde.')
#            pass
