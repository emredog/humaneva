function [lengths] = ComputeLimbLengths(markers, ParameterGroup)
% Computes limb lengths for the limbs defined in the body model defined. 
% Body model contains 10 limbs.
%
% Format:
%   [LENGTHS] = ComputeLimbLengths(MARKERS, PARAM_GROUP)
%
% Input:
%   MARKERS     - marker data from the .C3D file
%                 This is a 2D array of size (time instances)x(number
%                 of markers).
%   PARAM_GROUP - parameter group for the .C3D file
%
% Output: 
%   LENGTHS     - limb lengths in (mm)
%       LENGTHS(1)  - torso length
%       LENGTHS(2)  - left asis length
%       LENGTHS(3)  - left upper leg length
%       LENGTHS(4)  - left lower leg length
%       LENGTHS(5)  - left foot length (not used currently)
%       LENGTHS(6)  - right asis length
%       LENGTHS(7)  - right upper leg length
%       LENGTHS(8)  - right lower leg length
%       LENGTHS(9)  - right foot length (not used currently)
%       LENGTHS(10) - left thorax-clavical length
%       LENGTHS(11) - left upper arm length
%       LENGTHS(12) - left lower arm length
%       LENGTHS(13) - left hand length (not used currently)
%       LENGTHS(14) - right thorax-clavicle length
%       LENGTHS(15) - right upper arm length
%       LENGTHS(16) - right lower arm length
%       LENGTHS(17) - right hand length (not used currently)
%       LENGTHS(18) - neck length
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

LEFT_RIGHT_SYM = 0;

define_markers;

lengths(1) = LimbLength(markers, JOINT_CENTER_THORAX, JOINT_CENTER_PELVIS);

lengths(2) = LimbLength(markers, JOINT_CENTER_PELVIS, JOINT_CENTER_LEFT_HIP);
lengths(3) = LimbLength(markers, JOINT_CENTER_LEFT_HIP, JOINT_CENTER_LEFT_KNEE);
lengths(4) = LimbLength(markers, JOINT_CENTER_LEFT_KNEE, JOINT_CENTER_LEFT_ANKLE);
lengths(5) = 0.0;

lengths(6) = LimbLength(markers, JOINT_CENTER_PELVIS, JOINT_CENTER_RIGHT_HIP);
lengths(7) = LimbLength(markers, JOINT_CENTER_RIGHT_HIP, JOINT_CENTER_RIGHT_KNEE);
lengths(8) = LimbLength(markers, JOINT_CENTER_RIGHT_KNEE, JOINT_CENTER_RIGHT_ANKLE);
lengths(9) = 0.0;

if (LEFT_RIGHT_SYM)
    lengths(2:5) = mean([lengths(2:5);lengths(6:9)]);
    lengths(6:9) = lengths(2:5);
end

lengths(10) = LimbLength(markers, JOINT_CENTER_THORAX, JOINT_CENTER_LEFT_CLAVICLE);
lengths(11) = LimbLength(markers, JOINT_CENTER_LEFT_SHOULDER, JOINT_CENTER_LEFT_ELBOW); 
lengths(12) = LimbLength(markers, JOINT_CENTER_LEFT_ELBOW, JOINT_CENTER_LEFT_WRIST);
lengths(13) = 0.0;

lengths(14) = LimbLength(markers, JOINT_CENTER_THORAX, JOINT_CENTER_RIGHT_CLAVICLE);
lengths(15) = LimbLength(markers, JOINT_CENTER_RIGHT_SHOULDER, JOINT_CENTER_RIGHT_ELBOW); 
lengths(16) = LimbLength(markers, JOINT_CENTER_RIGHT_ELBOW, JOINT_CENTER_RIGHT_WRIST);
lengths(17) = 0.0;
 
if (LEFT_RIGHT_SYM)
    lengths(10:13) = mean([lengths(10:13);lengths(14:17)]);
    lengths(14:17) = lengths(10:13);
end

lengths(18) = 316.103; % this should the the neck length	   

%%%%%%%
%%%
%%%%%
function [length] = LimbLength(markers, from, to)
numSamples = size(markers,1);
from_joint_location = reshape(markers(:,from,:),numSamples,3);
to_joint_location = reshape(markers(:,to,:),numSamples,3);
bad_time_instances = [find(sum(from_joint_location == 0,2) == 3); ...
                      find(sum(to_joint_location == 0,2) == 3)];
from_joint_location(bad_time_instances,:) = [];
to_joint_location(bad_time_instances,:) = [];
length = mean(sqrt(sum((from_joint_location - to_joint_location).^2,2)));
