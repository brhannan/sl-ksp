classdef SLKSPMessenger < matlab.System & matlab.system.mixin.Propagates & ...
        matlab.system.mixin.CustomIcon
    %KSP.SLKSPMessenger communicate with Kerbal Space Program.
    %   K = KSP.SLKSPMESSENGER creates a new KSP.SLKSPMESSENGER System 
    %   object. KSP.SLKSPMESSENGER uses kRPC to transmit commands to/from 
    %   an instance of Kerbal Space Program.
    %
    %   See https://krpc.github.io/krpc/.
    
    %    Copyright 2020 Brian Hannan.
    
    % The SLKSPMessenger System object uses the SLKSPMessenger class 
    % defined in SLKSPMessenger.py to communicate with the kRPC server.

    properties(Hidden,Nontunable)
        %SLKSPComm slksp.SLKSPMessenger
        %   KSPComm is a SLKSPMessenger object.
        SLKSPComm
        %Vessel Vessel object
        %   Vessel is the SpaceCenter.Vessel object returned by
        %   SpaceCenter.active_vessel().
        Vessel
        %InputBusName Input bus
        %   The name of the input bus object.
        InputBusName = 'kspRxIn'
        %OutputBusName Output bus
        %   The name of the output bus object.
        OutputBusName = 'kspRxOut'
    end
    
    properties(DiscreteState)
        %CurrentThrottleValue Current throttle value.
        %   The current throttle value. Used to detect throttle setting
        %   change.
        CurrentThrottleValue
    end

    properties(Access=protected)
        % autopilot state
        AutopilotEngaged = false;
        % SAS state
        SASEngaged = false;
    end

    methods
        % Constructor
        function obj = SLKSPMessenger(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)

        % Common functions

        function setupImpl(obj)
            % connect to KSP
            obj.connect();
        end

        function y = stepImpl(obj,u)
            
            %--- receive ---
            
            % vessel
            y.vessel.liquidFuelAmt = obj.SLKSPComm.get_liquid_fuel();
            y.vessel.solidFuelAmt = obj.SLKSPComm.get_solid_fuel();
            y.vessel.met = obj.SLKSPComm.get_met();
            y.vessel.apoapsisAltitude = obj.SLKSPComm.get_vehicle_apoapsis_altitude();
            y.vessel.periapsisAltitude = obj.SLKSPComm.get_vehicle_periapsis_altitude();
            y.vessel.timeToApoapsis = obj.SLKSPComm.get_time_to_apoapsis();
            y.vessel.timeToPeriapsis = obj.SLKSPComm.get_time_to_periapsis();
            y.vessel.eccentricity = obj.SLKSPComm.get_eccentricity();
            y.vessel.inclination = obj.SLKSPComm.get_inclination();
            y.vessel.orbitalSpeed = obj.SLKSPComm.get_orbital_speed();
            % flight
            y.flight.meanAltitude = obj.SLKSPComm.get_mean_altitude();
            y.flight.surfaceAltitude = obj.SLKSPComm.get_surface_altitude();
            y.flight.latitude = obj.SLKSPComm.get_lat();
            y.flight.longitude = obj.SLKSPComm.get_lon();
            y.flight.velocity = obj.SLKSPComm.get_vel();
            y.flight.pitch = obj.SLKSPComm.get_pitch();
            y.flight.heading = obj.SLKSPComm.get_heading();
            y.flight.gForce = obj.SLKSPComm.get_g_force();
            y.flight.horizontalSpeed = obj.SLKSPComm.get_horizontal_speed();
            y.flight.verticalSpeed = obj.SLKSPComm.get_vertical_speed();
            % Get velocity vector and convert tuple to array.
            vtup = obj.SLKSPComm.get_vel();
            vel = cell2mat(cell(vtup));
            y.flight.velocity = vel;
            y.flight.gForce = obj.SLKSPComm.get_g_force();
            
            %--- send ---
            
            obj.SLKSPComm.set_pitch_and_heading( ...
                    u.autopilot.targetPitch, u.autopilot.targetHeading);

            % Engage/disengage autopilot if requested.
            if u.autopilot.engage && ~obj.AutopilotEngaged
                obj.SLKSPComm.engage_autopilot;
                obj.AutopilotEngaged = true;
            end
            % The block below is commented b/c disengage function has not
            % been implemented yet.
%             if ~u.autopilot.engage && obj.AutopilotEngaged
%                 obj.SLKSPComm.disengage_autopilot;
%                 obj.AutopilotEngaged = false;
%             end
            
            % Engage/disengage stability assist if requested.
            if u.control.sas && ~obj.SASEngaged
                obj.SLKSPComm.engage_sas;
                obj.SASEngaged = true;
            end
            % The block below is commented b/c disengage function has not
            % been implemented yet.
%             if ~u.control.sas && obj.SASEngaged
%                 obj.SLKSPComm.disengage_sas;
%                 obj.SASEngaged = false;
%             end

            % Activate next stage if requested.
            if u.control.activateNextStage
                obj.SLKSPComm.activate_next_stage();
            end
            
            % Set throttle if requested setting is not equal to current
            % throttle setting.
            if u.control.throttle ~= obj.CurrentThrottleValue
                obj.SLKSPComm.set_throttle(u.control.throttle);
                obj.CurrentThrottleValue = u.control.throttle;
            end
            
            % Lines below are commented b/c retrograde not supported yet.
            
            % Command SAS to drive vessel to prograde or retrograde if
            % requested.
            if u.autopilot.commandPrograde
                obj.SLKSPComm.set_sas_mode_prograde();
            end
%             if u.autopilot.commandRetrograde
%                 obj.SLKSPComm.set_sas_mode_retrograde();
%             end
            
            % Get current values for all reference frames if requested. 
            % This command tells slksp.SLKSPMessenger to update its 
            % reference frame states. For example, use this command to 
            % get new orbit and celestial body frames after entering a new
            % orbit.
            % Reference frames are initialized automatically by
            % slksp.SLKSPMessenter, so this request is only required after
            % major events in the post-launch mission timeline. There is no
            % need to make this request before launch.
            if u.control.resetReferenceFrames
                obj.SLKSPComm.get_all_ref_frames();
            end
            
        end % stepImpl

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.CurrentThrottleValue = 0;
        end

        % Backup/restore functions

        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj
            s = saveObjectImpl@matlab.System(obj);
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        % Simulink functions

        function ds = getDiscreteStateImpl(obj)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function flag = isInputSizeMutableImpl(obj,index)
            % Return false if input size cannot change between calls
            flag = false;
        end

        function icon = getIconImpl(obj)
            % define icon for System block
            icon = "KSP TX/RX";
        end

        function out = getOutputDataTypeImpl(obj)
            out = obj.OutputBusName;
        end
        
        function out = getInputDataTypeImpl(obj)
            out = obj.InputBusName;
        end

    end % protected methods

    methods(Static, Access = protected)

        % Simulink customization functions

        function header = getHeaderImpl()
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"));
        end

        function group = getPropertyGroupsImpl()
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(mfilename("class"));
        end

    end

    methods(Access=protected)

        function connect(obj)
            % connect to KSP via kRPC
            obj.SLKSPComm = py.slksp.SLKSPMessenger();
        end

    end % methods

end % SLKSPMessenger
