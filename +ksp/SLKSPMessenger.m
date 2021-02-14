classdef SLKSPMessenger < matlab.System & matlab.system.mixin.Propagates & ...
        matlab.system.mixin.CustomIcon
    %KSP.SLKSPMessenger communicate with Kerbal Space Program.
    %   K = KSP.SLKSPMESSENGER creates a new KSP.SLKSPMESSENGER System 
    %   object. KSP.SLKSPMESSENGER uses kRPC to transmit commands to/from 
    %   an instance of Kerbal Space Program.
    %
    %   See https://krpc.github.io/krpc/.
    
    % The SLKSPMessenger System object uses the SLKSPMessenger class 
    % defined in src/slksp.py to communicate with the kRPC server.

    %#codegen
    %#ok<*EMCA>

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

    % temp props for development -----------------------------------------------
    properties(Hidden,Nontunable)
        %OutputBusStruct Struct created from InputBusName bus. For dev use.
        OutputBusStruct
    end
    % --------------------------------------------------------------------------

    properties(Access=protected)
        % autopilot state
        AutopilotEngaged = false;
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
            obj.connect();

%             % get out bus struct (for dev test only) ---------------------------
%             obj.OutputBusStruct = ksp.bus.getFromKSPBus();
%             % ------------------------------------------------------------------
        end

        function y = stepImpl(obj,u)
            
            %--- receive ---
            
            % vessel
            y.vessel.liquidFuelAmt = obj.SLKSPComm.get_liquid_fuel();
            y.vessel.solidFuelAmt = obj.SLKSPComm.get_solid_fuel();
            y.vessel.met = obj.SLKSPComm.get_met();
            % flight
            y.flight.meanAltitude = obj.SLKSPComm.get_mean_altitude();
            y.flight.surfaceAltitude = obj.SLKSPComm.get_surface_altitude();
            y.flight.latitude = obj.SLKSPComm.get_lat();
            y.flight.longitude = obj.SLKSPComm.get_lon();
            % get velocity vector, convert tuple to array
            vtup = obj.SLKSPComm.get_vel();
            vel = cell2mat(cell(vtup));
            y.flight.velocity = vel;
            
            %--- send ---
            
%             % autopilot settings
%             if u.autopilot.engage && ~obj.AutopilotEngaged
%                 % set autopilot pitch, heading
%                 obj.Vessel.auto_pilot.target_pitch_and_heading( ...
%                     u.autopilot.targetPitch, u.autopilot.targetHeading);
%                 obj.Vessel.control.throttle = 1; % --- test only ---
%                 % engage autopilot
%                 obj.Vessel.auto_pilot.engage();
%                 obj.AutopilotEngaged = true;
%                 fprintf('Autopilot engaged\n');
%             end
%
%             % activate next stage
%             if u.control.activateNextStage
%                 obj.activateNextStage();
%                 fprintf('Next stage activated\n');
%             end

            % autopilot settings
            if u.autopilot.engage && ~obj.AutopilotEngaged
                % set autopilot pitch, heading
                obj.SLKSPComm.set_pitch_and_heading( ...
                    u.autopilot.targetPitch, u.autopilot.targetHeading);
                obj.SLKSPComm.set_throttle(1); % --- TODO: allow user to set this val ---
                obj.SLKSPComm.engage_autopilot;
                obj.AutopilotEngaged = true;
                fprintf('Autopilot engaged.\n');
            end

            % activate next stage
            if u.control.activateNextStage
                obj.SLKSPComm.activate_next_stage();
                fprintf('Next stage activated.\n');
            end
            
        end % stepImpl

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        % Backup/restore functions

        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            % s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty;

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        % Simulink functions

        function ds = getDiscreteStateImpl(obj)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function flag = isInputSizeMutableImpl(obj,index)
            % Return false if input size cannot change
            % between calls to the System object
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

end
