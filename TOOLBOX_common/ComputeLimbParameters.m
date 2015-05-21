function [params] = ComputeLimbParameters(markers, ParameterGroup, mpfilename)
% Computes the 3D conic parameters of limbs for the body model defined. Body
% model contains 10 limbs, for each limb 4 parameters are estimated.
%
% Format:
%   [PARAMS] = ComputeLimbParameters(MARKERS, PARAM_GROUP, MP_FILENAME)
%
% Input:
%   MARKERS     - marker data from the .C3D file
%                 This is a 2D array of size (time instances)x(number
%                 of markers).
%   PARAM_GROUP - parameter group for the .C3D file
%   MP_FILENAME - full path pathname to the .MP subject file
%
% Output: 
%   PARAMS      - conic parameters for each limb in the body model
%
%     The params are defined as follows:
%
%                    +------------+---------------+-----------+-----------+                    
%                    | top radius | bottom radius | x-scaling | y-scaling |                     
%  +-----------------+------------+---------------+-----------+-----------+
%  | torso           |
%  | left thigh      |
%  | left calf       |
%  | right thigh     |
%  | right calf      |                      10 x 5 matrix 
%  | left upper arm  |
%  | left lower arm  |
%  | right upper arm |
%  | right lower arm |
%  | head            |
%  +-----------------+----------------------------------------------------+
%
% Written by: Leonid Sigal 
% Revision:   1.1
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

define_markers;

MARKER_SIZE  = 14.0;
HALF_MARKER_SIZE = MARKER_SIZE / 2.0;

numSamples = size(markers,1);
params = zeros(10, 5);

% TORSO
left_shoulder_marker_data  = reshape(markers(:,MARKER_LSHO,:),numSamples,3);
right_shoulder_marker_data = reshape(markers(:,MARKER_RSHO,:),numSamples,3);
params(1,1) = mean(sqrt(sum((left_shoulder_marker_data - ... 
                           right_shoulder_marker_data).^2,2))) / 2.0;
params(1,1) = params(1,1) - HALF_MARKER_SIZE;
params(1,2) = params(1,1);
sternem_marker_data  = reshape(markers(:,MARKER_STRN,:),numSamples,3);
t10_marker_data = reshape(markers(:,MARKER_T10,:),numSamples,3);
params(1,3) = mean(sqrt(sum((sternem_marker_data - ... 
                             t10_marker_data).^2,2))) / (2*params(1,1));
params(1,4) = 1.0;
     
% LEFT THIGH                         
params(2,1) = (params(1,1) + HALF_MARKER_SIZE) / 2.0;
[tmp1,tmp2,val] = readmp(mpfilename, 'LKneeWidth');
params(2,2) = val / 2.0;
params(2,3) = 1.0;
params(2,4) = 1.0;

% LEFT CALF
[tmp1,tmp2,val] = readmp(mpfilename, 'LKneeWidth');
params(3,1) = val / 2.0;
[tmp1,tmp2,val] = readmp(mpfilename, 'LAnkleWidth');
params(3,2) = val / 2.0;
params(3,3) = 1.0;
params(3,4) = 1.0;

% RIGHT THIGH                         
params(4,1) = (params(1,1) + HALF_MARKER_SIZE) / 2.0;
[tmp1,tmp2,val] = readmp(mpfilename, 'RKneeWidth');
params(4,2) = val / 2.0;
params(4,3) = 1.0;
params(4,4) = 1.0;

% RIGHT CALF
[tmp1,tmp2,val] = readmp(mpfilename, 'RKneeWidth');
params(5,1) = val / 2.0;
[tmp1,tmp2,val] = readmp(mpfilename, 'RAnkleWidth');
params(5,2) = val / 2.0;
params(5,3) = 1.0;
params(5,4) = 1.0;

% LEFT UPPER ARM
[tmp1,tmp2,val] = readmp(mpfilename, 'LShoulderOffset');
params(6,1) = val;
[tmp1,tmp2,val] = readmp(mpfilename, 'LElbowWidth');
params(6,2) = val / 2.0;
params(6,3) = 1.0;
params(6,4) = 1.0;
       
% LEFT LOWER ARM
[tmp1,tmp2,val] = readmp(mpfilename, 'LElbowWidth');
params(7,1) = val / 2.0;
[tmp1,tmp2,val] = readmp(mpfilename, 'LWristWidth');
params(7,2) = val / 2.0;
params(7,3) = 1.0;
params(7,4) = 1.0;
        
% RIGHT UPPER ARM
[tmp1,tmp2,val] = readmp(mpfilename, 'RShoulderOffset');
params(8,1) = val;
[tmp1,tmp2,val] = readmp(mpfilename, 'RElbowWidth');
params(8,2) = val / 2.0;
params(8,3) = 1.0;
params(8,4) = 1.0;
       
% RIGHT LOWER ARM
[tmp1,tmp2,val] = readmp(mpfilename, 'RElbowWidth');
params(9,1) = val / 2.0;
[tmp1,tmp2,val] = readmp(mpfilename, 'RWristWidth');
params(9,2) = val / 2.0;
params(9,3) = 1.0;
params(9,4) = 1.0;

% HEAD
left_back_head_marker_data   = reshape(markers(:,MARKER_LBHD,:),numSamples,3);
left_front_head_marker_data  = reshape(markers(:,MARKER_LFHD,:),numSamples,3);
right_front_head_marker_data = reshape(markers(:,MARKER_RFHD,:),numSamples,3);
right_back_head_marher_data  = reshape(markers(:,MARKER_RBHD,:),numSamples,3);
params(10,1) = mean(sqrt(sum((left_back_head_marker_data - ... 
                              right_front_head_marker_data).^2,2))) / 2.0;
params(10,2) = params(10,1);
params(10,3) = 1.0;
params(10,4) = mean(sqrt(sum((left_front_head_marker_data - ... 
                              right_front_head_marker_data).^2,2))) / (2*params(10,1));
[tmp1,tmp2,val] = readmp(mpfilename, 'HeadOffset');
params(10,5) = val / 180 * pi;

