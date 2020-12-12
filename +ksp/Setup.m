classdef Setup < matlab.System
    %KSP.SETUP Set up Simulink / KSP connection.

    % Public, tunable properties
    properties
        Name = '-1'
        Address = '-1'
        RPCPort = -1
        StreamPort = -1
    end
    
    properties(Hidden)
        Conn
    end

    % Public, non-tunable properties
    properties(Nontunable)
        KSPTxBlockPath = '' % path to tx block that was found in model
        KSPRxBlockPath = '' % path to rx block that was found in model
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        KSPTxMaskType = 'ksp.Send'
        KSPRxMaskType = 'ksp.Receive'
    end

    methods
        % Constructor
        function obj = Setup(varargin)
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        
        function setupImpl(obj)
            % get path to KSP TX, RX blocks
            obj.getKSPTxRxBlockPaths();
            obj.Conn = py.krpc.connect();
            % put conn obj in base ws
            connVarName = 'kRPCConn';
            assignin('base','kRPCConn','obj.Conn');
            % set Conn property for tx block
            if isempty(obj.KSPTxBlockPath)
                error('ksp:Setup:txBlockNotFound', ...
                    'Empty path for %s block.',obj.KSPTxMaskType);
            end
            set_param(obj.KSPTxBlockPath,'Conn',connVarName)
            % set Conn property for rx block
            if isempty(obj.KSPRxBlockPath)
                error('ksp:Setup:rxBlockNotFound', ...
                    'Empty path for %s block.',obj.KSPRxBlockPath);
            end
            set_param(obj.KSPRxBlockPath,'Conn',connVarName)
        end % setupImpl
        
        function validatePropertiesImpl(obj)
            validateattributes(obj.Name,{'char'},{},'','Name');
            validateattributes(obj.Address,{'char'},{},'','Address');
            validateattributes(obj.RPCPort,{'numeric'},{'scalar'},'','RPCPort');
            validateattributes(obj.StreamPort,{'numeric'},{'scalar'},'','StreamPort');
        end

        function stepImpl(obj)
            % do nothing
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        % backup/restore functions
        
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

        function out = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            % icon = mfilename("class"); % Use class name
            icon = "kRPC"; % Example: text icon
            % icon = ["My","System"]; % Example: multi-line text icon
            % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
        end
    end

    methods(Static, Access = protected)
        
        % Simulink customization functions
        
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"));
        end

        function group = getPropertyGroupsImpl
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(mfilename("class"));
        end
        
    end % static protected methods
    
    methods
        
        function connect(obj)
            % connect to KSP via kRPC
            obj.Conn = py.krpc.connect();
        end
        
        function getKSPTxRxBlockPaths(obj)
            % get path to ksp.Send, ksp.Receive blocks in model
            txBlocks = find_system(bdroot,'MaskType',obj.KSPTxMaskType);
            if numel(txBlocks) ~= 1
                error('ksp:Setup:incorrectNumTxBlks', ...
                    'Model %s must have exactly 1 %s block.', ...
                    bdroot,obj.KSPTxMaskType);
            end
            txBlk = txBlocks{1};
            rxBlocks = find_system(bdroot,'MaskType',obj.KSPRxMaskType);
            if numel(rxBlocks) ~= 1
                error('ksp:Setup:incorrectNumRxBlks', ...
                    'Model %s must have exactly 1 %s block.', ...
                    bdroot,obj.KSPRxMaskType);
            end
            rxBlk = rxBlocks{1};
            obj.KSPTxBlockPath = txBlk;
            obj.KSPRxBlockPath = rxBlk;
        end % getKSPTxRxBlockPaths
        
        function [tf1,tf2,tf3,tf4] = wereConnPropsProvided(obj)
            % check whether kRPC connection params were provided
            defaultName = '-1';
            defaultAddress = '-1';
            defaultRPCPort = -1;
            defaultStreamPort = -1;
            tf1 = strcmp(obj.Name,defaultName);
            tf2 = strcmp(obj.Address,defaultAddress);
            tf3 = isequal(defaultRPCPort,obj.RPCPort);
            tf4 = isequal(defaultStreamPort,obj.StreamPort);
        end % wereConnPropsProvided
        
    end % methods
    
end