classdef FreeDiffusionModel < IMotionModel
    properties(Access = private)
        diffCoeff; % diffusion coefficient
        dt; % sampling period
        rngState; % random number generator state
        dm; % DataManager
        axis;
    end
    
    methods
        % Constructor
        function obj = FreeDiffusionModel(diffCoeff,dt,seed,axis,dm)
            obj.diffCoeff = diffCoeff;
            obj.dt = dt;
            obj.axis = axis;
            obj.dm = dm;
            obj.rngState = RandStream('mlfg6331_64','Seed',seed);
        end
        
        % Evaluates the transition function for a free diffusion.
        function out = Evaluate(obj,currPos,prevPos)
            stdDev = sqrt(2 * obj.diffCoeff * obj.dt);
            mean = prevPos;
            out = normpdf(currPos,mean,stdDev);
        end
        
        % Samples from a free diffusion given the previous position.
        function out = Sample(obj,prevPos)
            out = prevPos + ...
                sqrt(2 * obj.diffCoeff * obj.dt)*...
                randn(obj.rngState,size(prevPos));
        end
        function UpdateParameters(obj)
            switch(obj.axis)
                case 'x'
                    obj.diffCoeff = CalculateDiffusionCoefficient(obj.dm.xParticle);
                case 'y'
                    obj.diffCoeff = CalculateDiffusionCoefficient(obj.dm.yParticle);
                case 'z'
                    obj.diffCoeff = CalculateDiffusionCoefficient(obj.dm.zParticle);
                otherwise
            end
        end
    end
    methods(Access = private)
        function out = CalculateDiffusionCoefficient(obj,input)
            out = 0;
            for t = 1:(obj.dm.NumTimesteps()-1)
                for j = 1:obj.dm.numParticles()
                    for i = 1:obj.dm.numParticles()
                        out = out + obj.dm.wJoint(i,j,t)*...
                            (input(j,t+1) - input(i,t)).^2;
                    end
                end
            end
            out = out / ((obj.dm.numTimesteps()-1)*2*obj.dm.dt);
        end
    end
end