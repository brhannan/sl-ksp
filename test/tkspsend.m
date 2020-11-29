classdef tkspsend < matlab.unittest.TestCase
    %TKSPSEND Test suite for ksp.Send System object.
    
    methods (Test)
        
        function smoke(testCase)
            % Smoke test.
            ks = ksp.Send();
            ks.step(1);
        end % smoke
        
    end
    
end