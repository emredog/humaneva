function [this] = body_pose(varargin);
% BODY_POSE class encompases the body pose, and is used to compute error 
% from the ground truth motion capture data. 
%
% Syntax: 
%       [this] = BODY_POSE(this) - Copy constructor
% 
%       [this] = BODY_POSE       - Default constructor, all variables set
%                                  to zeros. 
%       [this] = BODY_POSE('torsoProximal', VAL, ...)
%                                - Uses supplied variable name/value pairs
%                                  to initialize the class. 
%                VAL is 3x1 or 1x3 position in 3D in (mm) or 
%                VAL is 2x1 or 1x2 position in the image in (pix). 
%
% Variables:    
%                           (Torso)
%   torsoProximal       - marker corresponding to the upper end of the torso
%   torsoDistal         - marker corresponding to the lower end of the torso
%
%                           (Upper Body)
%   upperLArmProximal   - left shoulder joint center
%   upperLArmDistal     - left elbow joint center
%   lowerLArmProximal   - left elbow joint center
%                           (for tree structured models 
%                               upperLArmDistal == lowerLArmProximal
%                            for models that treat parts independently
%                               upperLArmDistal != lowerLArmProximal)
%   lowerLArmDistal     - left wrist joint center 
%   upperRArmProximal   - right shoulder joint center
%   upperRArmDistal     - right elbow joint center
%   lowerRArmProximal   - right elbow joint center
%                           (for tree structured models 
%                               upperRArmDistal == lowerRArmProximal
%                            for models that treat parts independently
%                               upperRArmDistal != lowerRArmProximal)
%   lowerRArmDistal     - right wrist joint center 
%
%                           (Lower Body)
%   upperLLegProximal   - left hip joint center 
%   upperLLegDistal     - left knee joint center
%   lowerLLegProximal   - left knee joint center
%                           (for tree structured models 
%                               upperLLegDistal == lowerLLegProximal 
%                            for models that treat parts independently
%                               upperLLegDistal != lowerLLegProximal)
%   lowerLLegDistal     - left ankle joint center
%   upperRLegProximal   - right hip joint center 
%   upperRLegDistal     - right knee joint center
%   lowerRLegProximal   - right knee joint center
%                           (for tree structured models 
%                               upperRLegDistal == lowerRLegProximal 
%                            for models that treat parts independently
%                               upperRLegDistal != lowerRLegProximal)
%   lowerRLegDistal     - right ankle joint center
%
%                           (Head)
%   headProximal        - marker corresponding to the base of the neck
%                           (for tree structured models it's likely that
%                               headDistal == torsoProximal) 
%   headDistal          - marker corresponding to the top of the head
% 
% Written by: Leonid Sigal 
% Revision:   1.0
% Date:       5/12/2006
%
% Copyright 2006, Brown University 
% All Rights Reserved Permission to use, copy, modify, and distribute this 
% software and its documentation for any non-commercial purpose is hereby 
% granted without fee, provided that the above copyright notice appear in 
% all copies and that both that copyright notice and this permission 
% notice appear in supporting documentation, and that the name of the 
% author not be used in advertising or publicity pertaining to distribution 
% of the software without specific, written prior permission. 
% THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, 
% INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY 
% PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY 
% SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER 
% RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF 
% CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN 
% CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. 

s = struct( 'torsoProximal',        [0, 0, 0], ...
            'torsoDistal',          [0, 0, 0], ...
            'upperLArmProximal',    [0, 0, 0], ...
            'upperLArmDistal',      [0, 0, 0], ...
            'lowerLArmProximal',    [0, 0, 0], ...
            'lowerLArmDistal',      [0, 0, 0], ...
            'upperRArmProximal',    [0, 0, 0], ...
            'upperRArmDistal',      [0, 0, 0], ...
            'lowerRArmProximal',    [0, 0, 0], ...
            'lowerRArmDistal',      [0, 0, 0], ...
            'upperLLegProximal',    [0, 0, 0], ...
            'upperLLegDistal',      [0, 0, 0], ...
            'lowerLLegProximal',    [0, 0, 0], ...
            'lowerLLegDistal',      [0, 0, 0], ...
            'upperRLegProximal',    [0, 0, 0], ...
            'upperRLegDistal',      [0, 0, 0], ...
            'lowerRLegProximal',    [0, 0, 0], ...
            'lowerRLegDistal',      [0, 0, 0], ...
            'headProximal',         [0, 0, 0], ...
            'headDistal',           [0, 0, 0], ...
            'torsoProximalEnabled',        1, ...
            'torsoDistalEnabled',          1, ...
            'upperLArmProximalEnabled',    1, ...
            'upperLArmDistalEnabled',      1, ...
            'lowerLArmProximalEnabled',    1, ...
            'lowerLArmDistalEnabled',      1, ...
            'upperRArmProximalEnabled',    1, ...
            'upperRArmDistalEnabled',      1, ...
            'lowerRArmProximalEnabled',    1, ...
            'lowerRArmDistalEnabled',      1, ...
            'upperLLegProximalEnabled',    1, ...
            'upperLLegDistalEnabled',      1, ...
            'lowerLLegProximalEnabled',    1, ...
            'lowerLLegDistalEnabled',      1, ...
            'upperRLegProximalEnabled',    1, ...
            'upperRLegDistalEnabled',      1, ...
            'lowerRLegProximalEnabled',    1, ...
            'lowerRLegDistalEnabled',      1, ...
            'headProximalEnabled',         1, ...
            'headDistalEnabled',           1 ...            
        );
        
if (nargin == 0)
    this = class(s, 'body_pose');
end

if (nargin == 1)
    if (isa(varagin{1}, 'body_pose'))
        this = varagin{1};
    else
        error('Unsupported constructor option');
    end
end

if (floor(nargin / 2.0) == (nargin / 2.0))
    this = class(s, 'body_pose');
    try
        for I = 1:(nargin / 2)
            var = varargin{(I-1)*2+1};
            val = varargin{(I-1)*2+2};
            this = set(this, var, val);
        end
    catch
    	error('Unsupported constructor option');            
    end
else
	error('Unsupported constructor option');    
end
