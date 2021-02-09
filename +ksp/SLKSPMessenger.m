classdef SLKSPMessenger < matlab.System & matlab.system.mixin.Propagates & ...
        matlab.system.mixin.CustomIcon
    %KSP.SLKSPMessenger Use krpc to send messages to/from KSP.
    %   K = KSP.SLKSPMESSENGER creates a new KSP.SLKSPMESSENGER System object.
    %   KSP.SLKSPMESSENGER transmits commands to/from an instance of Kerbal
    %   Space Program.

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
            % obj.connect();

            % get out bus struct (for dev test only) ---------------------------
            obj.OutputBusStruct = ksp.bus.getFromKSPBus();
            % ------------------------------------------------------------------
        end

        function y = stepImpl(obj,u)
            y = obj.OutputBusStruct;
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
            obj.Conn = py.slksp.SLKSPMessenger();
        end

    end % methods

end
