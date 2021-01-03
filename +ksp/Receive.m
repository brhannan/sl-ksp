classdef Receive < matlab.System & matlab.system.mixin.Propagates & ...
        matlab.system.mixin.CustomIcon
    %KSP.RECEIVE Receive from Kerbal Space Program.
    %   KR = KSP.RECEIVE creates a new KSP.RECEIVE System object.
    %   KSP.RECEIVE receives data from an instance of Kerbal Space Program.

    %#codegen
    %#ok<*EMCA>

    properties(Hidden,Nontunable)
        %Rx slksp receive object
        Rx
        %OutputBusName Output bus
        %   The name of output bus object.
        OutputBusName = 'kspRxOut'
    end

    methods
        % Constructor
        function obj = Receive(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)

        % Common functions

        function setupImpl(obj)
            obj.connect();
        end

        function u = stepImpl(obj)
            % vessel
            u.vessel.liquidFuelAmt = obj.Rx.get_liquid_fuel();
            u.vessel.solidFuelAmt = obj.Rx.get_solid_fuel();
            u.vessel.met = obj.Rx.get_met();
            % flight
            u.flight.meanAltitude = obj.Rx.get_mean_altitude();
            u.flight.surfaceAltitude = obj.Rx.get_surface_altitude();
            u.flight.latitude = obj.Rx.get_lat();
            u.flight.longitude = obj.Rx.get_lon();
            % get velocity vector, convert tuple to array
            vtup = obj.Rx.get_vel();
            vel = cell2mat(cell(vtup));
            u.flight.velocity = vel;
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

        function cp = isOutputComplexImpl(obj)
            cp = false;
        end

        function sz = getOutputSizeImpl(obj,index)
            sz = 1;
        end

        function flag = isOutputFixedSizeImpl(obj,index)
            flag = true;
        end

        function flag = isOutputSizeMutableImpl(obj,index)
            % Return false if output size cannot change
            % between calls to the System object
            flag = false;
        end

        function icon = getIconImpl(obj)
            % define icon for System block
            % icon = mfilename("class"); % Use class name
            icon = "KSP RX"; % Example: text icon
        end

        function out = getOutputDataTypeImpl(obj)
            out = obj.OutputBusName;
        end

    end % protected methods

    methods(Static, Access = protected)

        % Simulink customization
        functions

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
            obj.Rx = py.slksp.Receive();
        end

    end % protected methods

end


% classdef Receive < matlab.System & matlab.system.mixin.Propagates & ...
%         matlab.system.mixin.CustomIcon
%     %KSP.RECEIVE Receive from Kerbal Space Program.
%     %   KR = KSP.RECEIVE creates a new KSP.RECEIVE System object.
%     %   KSP.RECEIVE receives data from an instance of Kerbal Space Program.
%
%     %#codegen
%     %#ok<*EMCA>
%
%     properties(Hidden,Nontunable)
%         %Conn kRPC connection object
%         %   Conn is the krpc.connection.Connection object returned by
%         %   krpc.connect().
%         Conn
%         %Vessel Vessel object
%         %   Vessel is the SpaceCenter.Vessel object returned by
%         %   SpaceCenter.active_vessel().
%         Vessel
%         %OutputBusName Output bus
%         %   The name of output bus object.
%         OutputBusName = 'kspRxOut'
%     end
%
%     methods
%         % Constructor
%         function obj = Send(varargin)
%             % Support name-value pair arguments when constructing object
%             setProperties(obj,nargin,varargin{:})
%         end
%     end
%
%     methods(Access = protected)
%
%         % Common functions
%
%         function setupImpl(obj)
%             obj.connect();
%             obj.getActiveVessel();
%         end
%
%         function u = stepImpl(obj)
%             % vessel
%             % liquid fuiel
%             try
%                 lf = obj.Vessel.resources.amount('LiquidFuel');
%             catch
%                 lf = 0;
%             end
%             u.vessel.liquidFuelAmt = lf;
%             try
%                 sf = obj.Vessel.resources.amount('SolidFuel');
%             catch
%                 warning('Unable to get solid fuel amount.');
%                 sf = -1;
%             end
%             u.vessel.solidFuelAmt = sf;
%             % flight
%             try
%                 % u.flight.meanAltitude = obj.Vessel.flight().mean_altitude;
%                 u.flight.meanAltitude = obj.Conn.get_call(py.getattr, obj.Vessel.flight(), 'mean_altitude');
%             catch
%                 warning('fancy mean alt call failed');
%                 u.flight.meanAltitude = -1;
%             end
%             try
%                 u.flight.surfaceAltitude = obj.Vessel.flight().surface_altitude;
%             catch
%                 u.flight.surfaceAltitude = -1;
%             end
%             try
%                 u.flight.latitude = obj.Vessel.flight().latitude;
%             catch
%                 u.flight.latitude = -1;
%             end
%             try
%                 u.flight.longitude = obj.Vessel.flight().longitude;
%             catch
%                 u.flight.longitude = -1;
%             end
%             try
%                 vel = obj.Vessel.flight(obj.Vessel.orbit.body.reference_frame).velocity;
%             catch
%                 warning('Unable to get velocity.');
%                 vel = zeros(1,3);
%             end
%             u.flight.velocity = vel;
%         end % stepImpl
%
%         function resetImpl(obj)
%             % Initialize / reset discrete-state properties
%         end
%
%         % Backup/restore functions
%
%         function s = saveObjectImpl(obj)
%             % Set properties in structure s to values in object obj
%
%             % Set public properties and states
%             s = saveObjectImpl@matlab.System(obj);
%
%             % Set private and protected properties
%             %s.myproperty = obj.myproperty;
%         end
%
%         function loadObjectImpl(obj,s,wasLocked)
%             % Set properties in object obj to values in structure s
%
%             % Set private and protected properties
%             % obj.myproperty = s.myproperty;
%
%             % Set public properties and states
%             loadObjectImpl@matlab.System(obj,s,wasLocked);
%         end
%
%         % Simulink functions
%
%         function ds = getDiscreteStateImpl(obj)
%             % Return structure of properties with DiscreteState attribute
%             ds = struct([]);
%         end
%
%         function cp = isOutputComplexImpl(obj)
%             cp = false;
%         end
%
%         function sz = getOutputSizeImpl(obj,index)
%             sz = 1;
%         end
%
%         function flag = isOutputFixedSizeImpl(obj,index)
%             flag = true;
%         end
%
%         function flag = isOutputSizeMutableImpl(obj,index)
%             % Return false if output size cannot change
%             % between calls to the System object
%             flag = false;
%         end
%
%         function icon = getIconImpl(obj)
%             % define icon for System block
%             % icon = mfilename("class"); % Use class name
%             icon = "KSP RX"; % Example: text icon
%         end
%
%         function out = getOutputDataTypeImpl(obj)
%             out = obj.OutputBusName;
%         end
%
%     end % protected methods
%
%     methods(Static, Access = protected)
%
%         % Simulink customization functions
%
%         function header = getHeaderImpl()
%             % Define header panel for System block dialog
%             header = matlab.system.display.Header(mfilename("class"));
%         end
%
%         function group = getPropertyGroupsImpl()
%             % Define property section(s) for System block dialog
%             group = matlab.system.display.Section(mfilename("class"));
%         end
%
%     end
%
%     methods(Access=protected)
%
%         function connect(obj)
%             % connect to KSP via kRPC
%             obj.Conn = py.krpc.connect();
%         end
%
%         function getActiveVessel(obj)
%             if isempty(obj.Conn)
%                 error('ksp:Send:connNotActive', ...
%                     'There is no active KSP connection.');
%             end
%             obj.Vessel = obj.Conn.space_center.active_vessel;
%         end
%
%     end % methods
%
% end
