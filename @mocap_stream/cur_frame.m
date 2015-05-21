function [this, pose, valid] = cur_frame(this, frame_id, mode)
% CUR_FRAME extracts the current frame from the MOCAP_STREAM
%
% Syntax:
%   [THIS, POSE, VALID] = cur_frame(THIS);
%   [THIS, POSE, VALID] = cur_frame(THIS, FRAME);
%   [THIS, POSE, VALID] = cur_frame(THIS, FRAME, MODE);
%
% Input:
%   THIS  - Input MOCAP_STREAM object.
%   FRAME - Current frame number in the mocap stream.
%   MODE  - Type of the result required. This will determine a type of the
%           object used for the pose. Valid values are 'body_pose' and 
%           'body_pose_xforms'.
%
% Output:
%   THIS  - Updated MOCAP_STREAM object.
%   POSE  - Pose of the body for the specified FRAME (or current frame if
%           frame is not specified). The type of the object will be 
%           specified by the MODE. By default the POSE will be of type 
%           BODY_POSE.
%   VALID - Boolean designating if the returned POSE is valid. Most likely
%           cause of the invalid data is the loss of marker data in the 
%           MoCap file.
%
% Written by: Leonid Sigal 
% Revision:   1.1
% Date:       3/16/2007
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

if (nargin < 3)
    mode = 'body_pose';
end

if (nargin > 1)
    this.current_position = this.stream_offset + (frame_id - 1) * this.stream_scaling;
end
 
if (ceil(this.current_position) > size(this.data.Markers,1))
    pose  = [];
    valid = 0;
    return;
end

ParameterGroup = this.data.ParameterGroup;
define_markers;
ANGLE_DECOMPOSITION_ORDER = 'ZXY';

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Does this frame contain valid mocap data?
%%%%%%%%%%%%%
midx     = zeros(1,39);
midx(1)  = min(MarkerName2MarkerId(ParameterGroup, 'RASI'));
midx(2)  = min(MarkerName2MarkerId(ParameterGroup, 'LASI'));
midx(3)  = min(MarkerName2MarkerId(ParameterGroup, 'LPSI'));
midx(4)  = min(MarkerName2MarkerId(ParameterGroup, 'RELB'));
midx(5)  = min(MarkerName2MarkerId(ParameterGroup, 'STRN'));
midx(6)  = min(MarkerName2MarkerId(ParameterGroup, 'LTHI'));
midx(7)  = min(MarkerName2MarkerId(ParameterGroup, 'LWRA'));
midx(8)  = min(MarkerName2MarkerId(ParameterGroup, 'LELB'));
midx(9)  = min(MarkerName2MarkerId(ParameterGroup, 'T10'));
midx(10) = min(MarkerName2MarkerId(ParameterGroup, 'RWRA'));
midx(11) = min(MarkerName2MarkerId(ParameterGroup, 'RUPA'));
midx(12) = min(MarkerName2MarkerId(ParameterGroup, 'RKNE'));
midx(13) = min(MarkerName2MarkerId(ParameterGroup, 'RBAK'));
midx(14) = min(MarkerName2MarkerId(ParameterGroup, 'LKNE'));
midx(15) = min(MarkerName2MarkerId(ParameterGroup, 'CLAV'));
midx(16) = min(MarkerName2MarkerId(ParameterGroup, 'RSHO'));
midx(17) = min(MarkerName2MarkerId(ParameterGroup, 'LSHO'));
midx(18) = min(MarkerName2MarkerId(ParameterGroup, 'C7'));
midx(19) = min(MarkerName2MarkerId(ParameterGroup, 'RTIB'));
midx(20) = min(MarkerName2MarkerId(ParameterGroup, 'LTIB'));
midx(21) = min(MarkerName2MarkerId(ParameterGroup, 'LBHD'));
midx(22) = min(MarkerName2MarkerId(ParameterGroup, 'RBHD'));
midx(23) = min(MarkerName2MarkerId(ParameterGroup, 'RFHD'));
midx(24) = min(MarkerName2MarkerId(ParameterGroup, 'LFHD'));
midx(25) = min(MarkerName2MarkerId(ParameterGroup, 'LANK'));
midx(26) = min(MarkerName2MarkerId(ParameterGroup, 'LHEE'));
midx(27) = min(MarkerName2MarkerId(ParameterGroup, 'RANK'));
midx(28) = min(MarkerName2MarkerId(ParameterGroup, 'LTOE'));
midx(29) = min(MarkerName2MarkerId(ParameterGroup, 'RTOE'));
midx(30) = min(MarkerName2MarkerId(ParameterGroup, 'RHEE'));
midx(31) = min(MarkerName2MarkerId(ParameterGroup, 'LFIN'));
midx(32) = min([MarkerName2MarkerId(ParameterGroup, 'RFRM'), ... 
                MarkerName2MarkerId(ParameterGroup, 'RFRA')]);
midx(33) = min([MarkerName2MarkerId(ParameterGroup, 'LFRM'), ...
                MarkerName2MarkerId(ParameterGroup, 'LFRA')]);
midx(34) = min(MarkerName2MarkerId(ParameterGroup, 'RWRB'));
midx(35) = min(MarkerName2MarkerId(ParameterGroup, 'RFIN'));
midx(36) = min(MarkerName2MarkerId(ParameterGroup, 'LWRB'));
midx(37) = min(MarkerName2MarkerId(ParameterGroup, 'RTHI'));
midx(38) = min(MarkerName2MarkerId(ParameterGroup, 'LUPA'));
midx(39) = min(MarkerName2MarkerId(ParameterGroup, 'RPSI'));

valid = 1;
if (any(sum(this.data.Markers(floor(this.current_position), midx, :),3) == 0))
    valid = 0;
end
if (any(sum(this.data.Markers(ceil(this.current_position), midx, :),3) == 0))
    valid = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compute Limb Lengths
%%%%%%%%%%%%%
tempMarkers = this.data.Markers([floor(this.current_position), ceil(this.current_position)], :, :);
lengths(1) = LimbLength(tempMarkers, JOINT_CENTER_THORAX, JOINT_CENTER_PELVIS);

lengths(2) = LimbLength(tempMarkers, JOINT_CENTER_PELVIS, JOINT_CENTER_LEFT_HIP);
lengths(3) = LimbLength(tempMarkers, JOINT_CENTER_LEFT_HIP, JOINT_CENTER_LEFT_KNEE);
lengths(4) = LimbLength(tempMarkers, JOINT_CENTER_LEFT_KNEE, JOINT_CENTER_LEFT_ANKLE);
lengths(5) = 0.0;

lengths(6) = LimbLength(tempMarkers, JOINT_CENTER_PELVIS, JOINT_CENTER_RIGHT_HIP);
lengths(7) = LimbLength(tempMarkers, JOINT_CENTER_RIGHT_HIP, JOINT_CENTER_RIGHT_KNEE);
lengths(8) = LimbLength(tempMarkers, JOINT_CENTER_RIGHT_KNEE, JOINT_CENTER_RIGHT_ANKLE);
lengths(9) = 0.0;

lengths(10) = LimbLength(tempMarkers, JOINT_CENTER_THORAX, JOINT_CENTER_LEFT_CLAVICLE);
lengths(11) = LimbLength(tempMarkers, JOINT_CENTER_LEFT_SHOULDER, JOINT_CENTER_LEFT_ELBOW); 
lengths(12) = LimbLength(tempMarkers, JOINT_CENTER_LEFT_ELBOW, JOINT_CENTER_LEFT_WRIST);
lengths(13) = 0.0;

lengths(14) = LimbLength(tempMarkers, JOINT_CENTER_THORAX, JOINT_CENTER_RIGHT_CLAVICLE);
lengths(15) = LimbLength(tempMarkers, JOINT_CENTER_RIGHT_SHOULDER, JOINT_CENTER_RIGHT_ELBOW); 
lengths(16) = LimbLength(tempMarkers, JOINT_CENTER_RIGHT_ELBOW, JOINT_CENTER_RIGHT_WRIST);
lengths(17) = 0.0;

lengths(18) = 316.103; 	   

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compute Global Transforms
%%%%%%%%%%%%%

% BODY
%    (pelvis)
globalTpelvis  = MarkerCoord2Xform(this.data.Markers, COORD_PELVIS, JOINT_CENTER_PELVIS, this.current_position);
globalTpelvis  = globalTpelvis * [eye(3,3), [0, 0, 0]'; 0, 0, 0, 1];
globalTlpelvis = MarkerCoord2Xform(this.data.Markers, COORD_PELVIS, JOINT_CENTER_PELVIS, this.current_position, yRotation(pi));
globalTrpelvis = MarkerCoord2Xform(this.data.Markers, COORD_PELVIS, JOINT_CENTER_PELVIS, this.current_position, yRotation(pi));  
%    (thorax)
globalTthorax  = MarkerCoord2Xform(this.data.Markers, COORD_THORAX, JOINT_CENTER_THORAX, this.current_position);
globalTlthorax = globalTthorax*xRotation(pi/2);
globalTrthorax = globalTthorax*xRotation(-pi/2);
%    (head)      
globalThead    = MarkerCoord2Xform(this.data.Markers, COORD_HEAD, JOINT_CENTER_HEAD, this.current_position);    
globalThead    = globalThead; 

% UPPER BODY
%   (left side)    
globalTlclavicle = MarkerCoord2Xform(this.data.Markers, COORD_LEFT_CLAVICLE,  JOINT_CENTER_LEFT_CLAVICLE, this.current_position);
globalTlshoulder = MarkerCoord2Xform(this.data.Markers, COORD_LEFT_UPPER_ARM, JOINT_CENTER_LEFT_SHOULDER, this.current_position);
globalTlelbow    = MarkerCoord2Xform(this.data.Markers, COORD_LEFT_LOWER_ARM, JOINT_CENTER_LEFT_ELBOW, this.current_position);
%   (right side)
globalTrclavicle = MarkerCoord2Xform(this.data.Markers, COORD_RIGHT_CLAVICLE,  JOINT_CENTER_RIGHT_CLAVICLE, this.current_position);
globalTrshoulder = MarkerCoord2Xform(this.data.Markers, COORD_RIGHT_UPPER_ARM, JOINT_CENTER_RIGHT_SHOULDER, this.current_position);
globalTrelbow    = MarkerCoord2Xform(this.data.Markers, COORD_RIGHT_LOWER_ARM, JOINT_CENTER_RIGHT_ELBOW, this.current_position);

% LOWER BODY
%   (left side)
globalTlthigh = MarkerCoord2Xform(this.data.Markers, COORD_LEFT_FEMUR, JOINT_CENTER_LEFT_HIP, this.current_position, yRotation(pi));
globalTltibia = MarkerCoord2Xform(this.data.Markers, COORD_LEFT_TIBIA, JOINT_CENTER_LEFT_KNEE, this.current_position, yRotation(pi));
%   (right side)
globalTrthigh = MarkerCoord2Xform(this.data.Markers, COORD_RIGHT_FEMUR, JOINT_CENTER_RIGHT_HIP, this.current_position, yRotation(pi));
globalTrtibia = MarkerCoord2Xform(this.data.Markers, COORD_RIGHT_TIBIA, JOINT_CENTER_RIGHT_KNEE, this.current_position, yRotation(pi));

% POSE MODIFIERS
globalTpelvis    = globalTpelvis * [eye(3),  [-50;0;0]; 0,0,0,1] * yRotation(atan2(this.Params(1,1)/2, lengths(1)));
% diff = (globalThead(1:3,:) * [0;0;0;1]) - (globalTpelvis(1:3,:) * [0;0;lengths(1);1]);
% globalThead(1:3,4) = (globalTpelvis(1:3,:) * [0;0;lengths(1);1]); % + diff;
% globalThead        = globalThead * yRotation(-atan2(this.Params(1,1)/2, lengths(1)));

diff = (globalTlelbow(1:3,:) * [0;0;0;1]) - (globalTlshoulder(1:3,:) * [0;0;-lengths(11);1]);
globalTlshoulder     = globalTlshoulder * yRotation(-atan2(this.Params(6,1)/2, lengths(11))); 
globalTlelbow(1:3,4) = (globalTlshoulder(1:3,:) * [0;0;-lengths(11);1]) + diff;
globalTlelbow        = globalTlelbow    * yRotation(atan2(this.Params(6,1)/2, lengths(11)));    

diff = (globalTrelbow(1:3,:) * [0;0;0;1]) - (globalTrshoulder(1:3,:) * [0;0;-lengths(15);1]);
globalTrshoulder     = globalTrshoulder * yRotation(-atan2(this.Params(8,1)/2, lengths(15)));    
globalTrelbow(1:3,4) = (globalTrshoulder(1:3,:) * [0;0;-lengths(15);1]) + diff;
globalTrelbow        = globalTrelbow    * yRotation(atan2(this.Params(8,1)/2, lengths(15))); 

if (nargin > 2)
    if (strcmp(mode, 'body_pose_xforms'))
        pose = body_pose_xforms; 

        pose = set(pose, 'torso', globalTpelvis);

        pose = set(pose, 'upperLArm', globalTlshoulder);
        pose = set(pose, 'lowerLArm', globalTlelbow);
        pose = set(pose, 'upperRArm', globalTrshoulder);
        pose = set(pose, 'lowerRArm', globalTrelbow);

        pose = set(pose, 'upperLLeg', globalTlthigh);
        pose = set(pose, 'lowerLLeg', globalTltibia);
        pose = set(pose, 'upperRLeg', globalTrthigh);
        pose = set(pose, 'lowerRLeg', globalTrtibia);

        pose = set(pose, 'head', globalThead);
     end
     
     if (strcmp(mode,'body_pose'))
        pose = body_pose; 
                
        % render torso
        pose = set(pose, 'torsoProximal',     (globalTpelvis(1:3,:)     * [0;0;lengths(1);1])');
        pose = set(pose, 'torsoDistal',       (globalTpelvis(1:3,:)     * [0;0;0;1])');
        pose = set(pose, 'upperLLegProximal', (globalTlthigh(1:3,:)     * [0;0;0;1])'); 
        pose = set(pose, 'upperLLegDistal',   (globalTlthigh(1:3,:)     * [0;0;lengths(3);1])'); 
        pose = set(pose, 'lowerLLegProximal', (globalTltibia(1:3,:)     * [0;0;0;1])'); 
        pose = set(pose, 'lowerLLegDistal',   (globalTltibia(1:3,:)     * [0;0;lengths(4);1])');                 
        pose = set(pose, 'upperRLegProximal', (globalTrthigh(1:3,:)     * [0;0;0;1])'); 
        pose = set(pose, 'upperRLegDistal',   (globalTrthigh(1:3,:)     * [0;0;lengths(7);1])'); 
        pose = set(pose, 'lowerRLegProximal', (globalTrtibia(1:3,:)     * [0;0;0;1])'); 
        pose = set(pose, 'lowerRLegDistal',   (globalTrtibia(1:3,:)     * [0;0;lengths(8);1])'); 
        pose = set(pose, 'upperLArmProximal', (globalTlshoulder(1:3,:)  * [0;0;0;1])'); 
        pose = set(pose, 'upperLArmDistal',   (globalTlshoulder(1:3,:)  * [0;0;-lengths(11);1])'); 
        pose = set(pose, 'lowerLArmProximal', (globalTlelbow(1:3,:)     * [0;0;0;1])'); 
        pose = set(pose, 'lowerLArmDistal',   (globalTlelbow(1:3,:)     * [0;0;-lengths(12);1])'); 
        pose = set(pose, 'upperRArmProximal', (globalTrshoulder(1:3,:)  * [0;0;0;1])'); 
        pose = set(pose, 'upperRArmDistal',   (globalTrshoulder(1:3,:)  * [0;0;-lengths(15);1])'); 
        pose = set(pose, 'lowerRArmProximal', (globalTrelbow(1:3,:)     * [0;0;0;1])'); 
        pose = set(pose, 'lowerRArmDistal',   (globalTrelbow(1:3,:)     * [0;0;-lengths(16);1])'); 
        pose = set(pose, 'headProximal',      (globalThead(1:3,:)       * [0;0;0;1])');         
        pose = set(pose, 'headDistal',        (globalThead(1:3,:)       * [0;0;lengths(18);1])'); 

        if (valid)
            pose = set(pose, 'torsoProximalEnabled',        1);
            pose = set(pose, 'torsoDistalEnabled',          1);
            pose = set(pose, 'upperLArmProximalEnabled',    1);
            pose = set(pose, 'upperLArmDistalEnabled',      1);
            pose = set(pose, 'lowerLArmProximalEnabled',    1);
            pose = set(pose, 'lowerLArmDistalEnabled',      1);
            pose = set(pose, 'upperRArmProximalEnabled',    1);
            pose = set(pose, 'upperRArmDistalEnabled',      1);
            pose = set(pose, 'lowerRArmProximalEnabled',    1);
            pose = set(pose, 'lowerRArmDistalEnabled',      1);
            pose = set(pose, 'upperLLegProximalEnabled',    1);
            pose = set(pose, 'upperLLegDistalEnabled',      1);
            pose = set(pose, 'lowerLLegProximalEnabled',    1);
            pose = set(pose, 'lowerLLegDistalEnabled',      1);
            pose = set(pose, 'upperRLegProximalEnabled',    1);
            pose = set(pose, 'upperRLegDistalEnabled',      1);
            pose = set(pose, 'lowerRLegProximalEnabled',    1);
            pose = set(pose, 'lowerRLegDistalEnabled',      1);
            pose = set(pose, 'headProximalEnabled',         1);
            pose = set(pose, 'headDistalEnabled',           1);
        else
            pose = set(pose, 'torsoProximalEnabled',        0);
            pose = set(pose, 'torsoDistalEnabled',          0);
            pose = set(pose, 'upperLArmProximalEnabled',    0);
            pose = set(pose, 'upperLArmDistalEnabled',      0);
            pose = set(pose, 'lowerLArmProximalEnabled',    0);
            pose = set(pose, 'lowerLArmDistalEnabled',      0);
            pose = set(pose, 'upperRArmProximalEnabled',    0);
            pose = set(pose, 'upperRArmDistalEnabled',      0);
            pose = set(pose, 'lowerRArmProximalEnabled',    0);
            pose = set(pose, 'lowerRArmDistalEnabled',      0);
            pose = set(pose, 'upperLLegProximalEnabled',    0);
            pose = set(pose, 'upperLLegDistalEnabled',      0);
            pose = set(pose, 'lowerLLegProximalEnabled',    0);
            pose = set(pose, 'lowerLLegDistalEnabled',      0);
            pose = set(pose, 'upperRLegProximalEnabled',    0);
            pose = set(pose, 'upperRLegDistalEnabled',      0);
            pose = set(pose, 'lowerRLegProximalEnabled',    0);
            pose = set(pose, 'lowerRLegDistalEnabled',      0);
            pose = set(pose, 'headProximalEnabled',         0);
            pose = set(pose, 'headDistalEnabled',           0);            
        end        
     end

     if (strcmp(mode, 'body_params'))
        pose = this.Params;
     end

     if (strcmp(mode, 'body_lengths'))
        pose = lengths;
     end
end
 

%%%%%%%
%%% LimbLength
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
