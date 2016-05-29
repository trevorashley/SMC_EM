classdef DataManager < handle
    properties(Access = private)
        numParticles;
        numTimesteps;
        numPixels;
    end
    
    properties
        % Important: MATLAB is column-major!
        % So, accessing x(1,1) through x(N,1) is faster than accessing
        % x(1,1) through x(1,N).  This is different from C++ where the
        % opposite happens.
        xSensor; % X Sensor Position [pixel][time]
        ySensor; % Y Sensor Position [pixel][time]
        zSensor; % Z Sensor Position [pixel][time]
        xParticle; % X Particle Position [particle][time]
        yParticle; % Y Particle Position [particle][time]
        zParticle; % Z Particle Position [particle][time]
        wFilter; % Filtered weights [particle][time]
        wSmooth; % Smoothed weights [particle][time]
        Data; % Measurements [pixel][time]
        wJoint; % Joint weights [particle][particle][time]
    end
    
    methods
        % Constructor
        function obj = DataManager(numParticles,numTimesteps,numPixels)
            obj.numParticles = numParticles;
            obj.numTimesteps = numTimesteps;
            obj.numPixels = numPixels;
            
            % Allocate space
            obj.xSensor = zeros(numPixels,numTimesteps);
            obj.ySensor = zeros(numPixels,numTimesteps);
            obj.zSensor = zeros(numPixels,numTimesteps);
            obj.xParticle = zeros(numParticles,numTimesteps);
            obj.yParticle = zeros(numParticles,numTimesteps);
            obj.zParticle = zeros(numParticles,numTimesteps);
            obj.wFilter = zeros(numParticles,numTimesteps);
            obj.wSmooth = zeros(numParticles,numTimesteps);
            obj.Data = zeros(numPixels,numTimesteps);
            obj.wJoint = zeros(numParticles,numParticles,numTimesteps);
        end
        
        % Accessors
        function out = NumParticles(obj)
            out = obj.numParticles;
        end
        function out = NumTimesteps(obj)
            out = obj.numTimesteps;
        end
        function out = NumPixels(obj)
            out = obj.numTimesteps;
        end
    end
end