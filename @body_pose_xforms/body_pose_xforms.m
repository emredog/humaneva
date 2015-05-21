function [this] = body_pose_xforms(varargin);
% BODY_POSE_XFORMS class encompases the body pose in terms of individual
% limb transforms. 
%
% Syntax: 
%       [this] = BODY_POSE_XFORMS(this) - Copy constructor
% 
%       [this] = BODY_POSE_XFORMS - Default constructor, all variables set
%                                   to eye(4). 
%       [this] = BODY_POSE_XFORMS('torso', VAL, ...)
%                                 - Uses supplied variable name/value pairs
%                                   to initialize the class. 
%                VAL is 4x4 matrix, corresponding to gloablTlocal. 
%
% Variables:    
%                           (Torso)
%   torso       - 4x4 transfrom corresponding to the torso in global
%                 coordinate frame
%
%                           (Upper Body)
%   upperLArm   - 4x4 transfrom corresponding to the upper left arm in 
%                 global coordinate frame
%   lowerLArm   - 4x4 transfrom corresponding to the lower left arm in 
%                 global coordinate frame
%   handL       - 4x4 transfrom corresponding to the left hand in global 
%                 coordinate frame
%
%   upperRArm   - 4x4 transfrom corresponding to the upper right arm in 
%                 global coordinate frame
%   lowerRArm   - 4x4 transfrom corresponding to the lower right arm in 
%                 global coordinate frame
%   handR       - 4x4 transfrom corresponding to the right hand in global 
%                 coordinate frame
% 
%                           (Lower Body)
%   upperLLeg   - 4x4 transfrom corresponding to the upper left leg in 
%                 global coordinate frame
%   lowerLLeg   - 4x4 transfrom corresponding to the lower left leg in 
%                 global coordinate frame
%   footL       - 4x4 transfrom corresponding to the right foot in global 
%                 coordinate frame
%
%   upperRLeg   - 4x4 transfrom corresponding to the upper right leg in 
%                 global coordinate frame
%   lowerRLeg   - 4x4 transfrom corresponding to the lower right leg in 
%                 global coordinate frame
%   footR       - 4x4 transfrom corresponding to the right foot in global 
%                 coordinate frame
%
%                           (Head)
%   head        - 4x4 transfrom corresponding to the head in global 
%                 coordinate frame
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

s = struct( 'torso',        eye(4), ...
            'upperLArm',    eye(4), ...
            'lowerLArm',    eye(4), ...  
            'upperRArm',    eye(4), ...
            'lowerRArm',    eye(4), ... 
            'upperLLeg',    eye(4), ...
            'lowerLLeg',    eye(4), ... 
            'upperRLeg',    eye(4), ...
            'lowerRLeg',    eye(4), ... 
            'head',         eye(4));
        
if (nargin == 0)
    this = class(s, 'body_pose_xforms');
end

if (nargin == 1)
    if (isa(varagin{1}, 'body_pose_xforms'))
        this = varagin{1};
    else
        error('Unsupported constructor option');
    end
end

if (floor(nargin / 2.0) == (nargin / 2.0))
    this = class(s, 'body_pose_xforms');
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
