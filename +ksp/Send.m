classdef Send < matlab.System & matlab.system.mixin.Propagates & ...
        matlab.system.mixin.CustomIcon
    %KSP.SEND Send commands to Kerbal Space Program.
    %   KS = KSP.SEND creates a new KSP.SEND System object. KSP.SEND
    %   transmits commands to an instance of Kerbal Space Program.
    
    %#codegen
    %#ok<*EMCA>
    
    properties(Hidden,Nontunable)
        %Conn kRPC connection object
        %   Conn is the krpc.connection.Connection object returned by
        %   krpc.connect().
        Conn
        %Vessel Vessel object
        %   Vessel is the SpaceCenter.Vessel object returned by
        %   SpaceCenter.active_vessel().
        Vessel
        %InputBusName Input bus
        %   The name of input bus object.
        InputBusName = 'kspTxIn'
    end
    
    properties(Access=protected)
        AutopilotEngaged = false;
    end

    methods
        % Constructor
        function obj = Send(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        
        % Common functions
        
        function setupImpl(obj)
            obj.connect();
            obj.getActiveVessel();
        end

        function stepImpl(obj,u)
            
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
                obj.Vessel.auto_pilot.target_pitch_and_heading( ...
                    u.autopilot.targetPitch, u.autopilot.targetHeading);
                obj.Vessel.control.throttle = 1; % --- test only ---
                obj.Vessel.auto_pilot.engage
                obj.AutopilotEngaged = true;
                fprintf('Autopilot engaged\n');
            end
            
            % activate next stage
            if u.control.activateNextStage
                obj.activateNextStage();
                fprintf('Next stage activated\n');
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
            %s.myproperty = obj.myproperty;
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
            % icon = mfilename("class"); % Use class name
            icon = "KSP TX"; % Example: text icon
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
            obj.Conn = py.krpc.connect();
        end
        
        function getActiveVessel(obj)
            if isempty(obj.Conn)
                error('ksp:Send:connNotActive', ...
                    'There is no active KSP connection.');
            end
            obj.Vessel = obj.Conn.space_center.active_vessel;
            % what if vessel isempty?
        end
        
        function activateNextStage(obj)
            obj.Vessel.control.activate_next_stage();
        end
        
    end % methods
    
end
