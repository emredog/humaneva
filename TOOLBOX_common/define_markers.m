% Script that defines the required markers in the c3d file.
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

% body
COORD_PELVIS = MarkerName2MarkerId(ParameterGroup, 'PELO');   
COORD_THORAX = MarkerName2MarkerId(ParameterGroup, 'TRXO'); 
COORD_HEAD = MarkerName2MarkerId(ParameterGroup, 'HEDO');
% lower body (left side)
COORD_LEFT_FEMUR = MarkerName2MarkerId(ParameterGroup, 'LFEO'); 
COORD_LEFT_TIBIA =  MarkerName2MarkerId(ParameterGroup, 'LTIO'); 
COORD_LEFT_FOOT = MarkerName2MarkerId(ParameterGroup, 'LFOO');   
COORD_LEFT_TOE = MarkerName2MarkerId(ParameterGroup, 'LTOO');  
% lower body (right side)
COORD_RIGHT_FEMUR = MarkerName2MarkerId(ParameterGroup, 'RFEO');   
COORD_RIGHT_TIBIA = MarkerName2MarkerId(ParameterGroup, 'RTIO');  
COORD_RIGHT_FOOT = MarkerName2MarkerId(ParameterGroup, 'RFOO');  
COORD_RIGHT_TOE = MarkerName2MarkerId(ParameterGroup, 'RTOO');   
% upper body (left side)
COORD_LEFT_CLAVICLE = MarkerName2MarkerId(ParameterGroup, 'LCLO');   
COORD_LEFT_UPPER_ARM = MarkerName2MarkerId(ParameterGroup, 'LHUO');   
COORD_LEFT_LOWER_ARM = MarkerName2MarkerId(ParameterGroup, 'LRAO');   
COORD_LEFT_HAND = MarkerName2MarkerId(ParameterGroup, 'LHNO');   
% upper body (right side)
COORD_RIGHT_CLAVICLE = MarkerName2MarkerId(ParameterGroup, 'RCLO');
COORD_RIGHT_UPPER_ARM = MarkerName2MarkerId(ParameterGroup, 'RHUO');   
COORD_RIGHT_LOWER_ARM = MarkerName2MarkerId(ParameterGroup, 'RRAO');   
COORD_RIGHT_HAND = MarkerName2MarkerId(ParameterGroup, 'RHNO');   

%%%%%%%%%%%%%%%%%%%%%%%%%
% Join Centers
%%%%%%
% body
JOINT_CENTER_PELVIS = MarkerName2MarkerId(ParameterGroup, 'PELO');     
JOINT_CENTER_THORAX = MarkerName2MarkerId(ParameterGroup, 'TRXO');   
JOINT_CENTER_HEAD = MarkerName2MarkerId(ParameterGroup, 'TRXO');   
% lower body (left side)
JOINT_CENTER_LEFT_HIP = MarkerName2MarkerId(ParameterGroup, 'LFEP');   
JOINT_CENTER_LEFT_KNEE = MarkerName2MarkerId(ParameterGroup, 'LFEO');      
JOINT_CENTER_LEFT_ANKLE = MarkerName2MarkerId(ParameterGroup, 'LTIO');   
% lower body (right side)
JOINT_CENTER_RIGHT_HIP = MarkerName2MarkerId(ParameterGroup, 'RFEP');
JOINT_CENTER_RIGHT_KNEE = MarkerName2MarkerId(ParameterGroup, 'RFEO');
JOINT_CENTER_RIGHT_ANKLE = MarkerName2MarkerId(ParameterGroup, 'RTIO');
% upper body (left side)
JOINT_CENTER_LEFT_CLAVICLE = MarkerName2MarkerId(ParameterGroup, 'LCLO');
JOINT_CENTER_LEFT_SHOULDER = MarkerName2MarkerId(ParameterGroup, 'LCLO');
JOINT_CENTER_LEFT_ELBOW    = MarkerName2MarkerId(ParameterGroup, 'LHUO');
JOINT_CENTER_LEFT_WRIST    = MarkerName2MarkerId(ParameterGroup, 'LRAO');
% upper body (right side)
JOINT_CENTER_RIGHT_CLAVICLE = MarkerName2MarkerId(ParameterGroup, 'RCLO');
JOINT_CENTER_RIGHT_SHOULDER = MarkerName2MarkerId(ParameterGroup, 'RCLO');
JOINT_CENTER_RIGHT_ELBOW    = MarkerName2MarkerId(ParameterGroup, 'RHUO');
JOINT_CENTER_RIGHT_WRIST    = MarkerName2MarkerId(ParameterGroup, 'RRAO');

%%%%%%%%%%%%%%%%%%%%
%%% Regular Markers
%%%%%%%%%%
MARKER_LSHO = MarkerName2MarkerId(ParameterGroup, 'LSHO');   
MARKER_RSHO = MarkerName2MarkerId(ParameterGroup, 'RSHO');   
MARKER_STRN = MarkerName2MarkerId(ParameterGroup, 'STRN');   
MARKER_T10  = MarkerName2MarkerId(ParameterGroup, 'T10');   
MARKER_LBHD = MarkerName2MarkerId(ParameterGroup, 'LBHD');   
MARKER_LFHD = MarkerName2MarkerId(ParameterGroup, 'LFHD');   
MARKER_RFHD = MarkerName2MarkerId(ParameterGroup, 'RFHD');   
MARKER_RBHD = MarkerName2MarkerId(ParameterGroup, 'RBHD');   