classdef (Abstract) IMotionModel
    methods (Abstract)
        out = Evaluate(obj,currPos,prevPos)
        out = Sample(obj,prevPos)
        UpdateParameters(obj)
    end
end
    