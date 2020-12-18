classdef Receive < matlab.System & matlab.system.mixin.Propagates & ...
        matlab.system.mixin.CustomIcon
    %KSP.RECEIVE Receive from Kerbal Space Program.
    %   KR = KSP.RECEIVE creates a new KSP.RECEIVE System object.
    %   KSP.RECEIVE receives data from an instance of Kerbal Space Program.

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
        %OutputBusName Output bus
        %   The name of output bus object.
        OutputBusName = 'kspRxOut'
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

        function u = stepImpl(obj)
            % vessel
            u.vessel.liquidFuelAmt = obj.Vessel.resources.amount('LiquidFuel');
            % flight
            u.flight.meanAltitude = obj.Vessel.flight().mean_altitude;
            u.flight.surfaceAltitude = obj.Vessel.flight().surface_altitude;
            u.flight.latitude = obj.Vessel.flight().latitude;
            u.flight.longitude = obj.Vessel.flight().longitude;
        end % stepImpl

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
%
%         function releaseImpl(obj)
%             obj.Conn = [];
%             obj.Vessel = [];
%         end

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
        end

        function activateNextStage(obj)
            obj.Vessel.control.activate_next_stage();
        end

    end % methods

end
