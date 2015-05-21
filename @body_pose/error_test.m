function [err, jname] = error_test(pose1, pose2)
% ERROR computes the error between the two body poses. 
%
% Syntax: 
%       [this] = ERROR(pose1, pose2) 
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

if (isa(pose1, 'body_pose') && (prod(size(pose1)) == 1) && ...
    isa(pose2, 'body_pose') && (prod(size(pose2)) == 1))
else
    error('Incompatible parameters'); 
end

err = [];
jname = {};

% Thorax joint 
err(1) = error_internal(pose1.torsoProximalEnabled, pose2.torsoProximalEnabled, ...
                    pose1.torsoProximal, pose2.torsoProximal);
jname{1} = 'torsoProximal';
err(2) = error_internal(pose1.torsoDistalEnabled, pose2.torsoDistalEnabled, ...
                    pose1.torsoDistal, pose2.torsoDistal);
jname{2} = 'torsoDistal';

% Left Upper Leg
err(3) = error_internal(pose1.upperLLegProximalEnabled, pose2.upperLLegProximalEnabled, ...
                    pose1.upperLLegProximal, pose2.upperLLegProximal);
jname{3} = 'upperLLegProximal';
err(4) = error_internal(pose1.upperLLegDistalEnabled, pose2.upperLLegDistalEnabled, ...
                    pose1.upperLLegDistal, pose2.upperLLegDistal);
jname{4} = 'upperLLegDistal';

% Left Lower Leg                
err(5) = error_internal(pose1.lowerLLegProximalEnabled, pose2.lowerLLegProximalEnabled, ...
                    pose1.lowerLLegProximal, pose2.lowerLLegProximal);
jname{5} = 'lowerLLegProximal';
err(6) = error_internal(pose1.lowerLLegDistalEnabled, pose2.lowerLLegDistalEnabled, ...
                    pose1.lowerLLegDistal, pose2.lowerLLegDistal);
jname{6} = 'lowerLLegDistal';              

% Right Upper Leg
err(7) = error_internal(pose1.upperRLegProximalEnabled, pose2.upperRLegProximalEnabled, ...
                    pose1.upperRLegProximal, pose2.upperRLegProximal);
jname{7} = 'upperRLegProximal';
err(8) = error_internal(pose1.upperRLegDistalEnabled, pose2.upperRLegDistalEnabled, ...
                    pose1.upperRLegDistal, pose2.upperRLegDistal);
jname{8} = 'upperRLegDistal';

% Right Lower Leg
err(9) = error_internal(pose1.lowerRLegProximalEnabled, pose2.lowerRLegProximalEnabled, ...
                    pose1.lowerRLegProximal, pose2.lowerRLegProximal);
jname{9} = 'lowerRLegProximal'; 
err(10)= error_internal(pose1.lowerRLegDistalEnabled, pose2.lowerRLegDistalEnabled, ...
                    pose1.lowerRLegDistal, pose2.lowerRLegDistal);
jname{10}= 'lowerRLegDistal';
                
                
% Left Upper Arm
err(11) = error_internal(pose1.upperLArmProximalEnabled, pose2.upperLArmProximalEnabled, ...
                    pose1.upperLArmProximal, pose2.upperLArmProximal);    
jname{11} = 'upperLArmProximal';
err(12) = error_internal(pose1.upperLArmDistalEnabled, pose2.upperLArmDistalEnabled, ...
                    pose1.upperLArmDistal, pose2.upperLArmDistal);
jname{12} = 'upperLArmDistal';

% Left Lower Arm
err(13) = error_internal(pose1.lowerLArmProximalEnabled, pose2.lowerLArmProximalEnabled, ...
                    pose1.lowerLArmProximal, pose2.lowerLArmProximal);
jname{13} = 'lowerLArmProximal';
err(14) = error_internal(pose1.lowerLArmDistalEnabled, pose2.lowerLArmDistalEnabled, ...
                    pose1.lowerLArmDistal, pose2.lowerLArmDistal);
jname{14} = 'lowerLArmDistal';

                
% Right Upper Arm 
err(15) = error_internal(pose1.upperRArmProximalEnabled, pose2.upperRArmProximalEnabled, ...
                    pose1.upperRArmProximal, pose2.upperRArmProximal);
jname{15} = 'upperRArmProximal';
err(16) = error_internal(pose1.upperRArmDistalEnabled, pose2.upperRArmDistalEnabled, ...
                    pose1.upperRArmDistal, pose2.upperRArmDistal);
jname{16} = 'upperRArmDistal';

% Right Lower Arm                
err(17) = error_internal(pose1.lowerRArmProximalEnabled, pose2.lowerRArmProximalEnabled, ...
                    pose1.lowerRArmProximal, pose2.lowerRArmProximal);
jname{17} = 'lowerRArmProximal';
err(18) = error_internal(pose1.lowerRArmDistalEnabled, pose2.lowerRArmDistalEnabled, ...
                    pose1.lowerRArmDistal, pose2.lowerRArmDistal);
jname{18} = 'lowerRArmDistal';

% Head 
err(19) = error_internal(pose1.headProximalEnabled, pose2.headProximalEnabled, ...
                     pose1.headProximal, pose2.headProximal);
jname{19} = 'headProximal'; 
err(20) = error_internal(pose1.headDistalEnabled, pose2.headDistalEnabled, ...
                    pose1.headDistal, pose2.headDistal);
jname{20} = 'headDistal'; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%
%%%%%%%%%%%%%%%%%%%%%%
        
function [err] = error_internal(enable1, enable2, point1, point2)

if (enable1 && enable2)
    err = sqrt(sum((point1(:) - point2(:)).^2));
else
    err = [];
end


