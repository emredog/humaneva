function [err] = error_rel(pose1, pose2)
% ERROR_REL computes the relative error between the two body poses. The 
% relative pose is computed with respect to the torsoDistal joint. 
%
% Syntax: 
%       [this] = ERROR(pose1, pose2) 
% 
% Written by: Leonid Sigal 
% Revision:   1.0
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

if (isa(pose1, 'body_pose') && (prod(size(pose1)) == 1) && ...
    isa(pose2, 'body_pose') && (prod(size(pose2)) == 1))
else
    error('Incompatible parameters'); 
end

err = [];

% Thorax joint 
e1 = error_internal(pose1.torsoProximalEnabled, pose2.torsoProximalEnabled, ...
                    pose1.torsoProximal - pose1.torsoDistal, ...
                    pose2.torsoProximal - pose2.torsoDistal);
e2 = error_internal(pose1.headDistalEnabled, pose2.headDistalEnabled, ...
                    pose1.headDistal - pose1.torsoDistal, ...
                    pose2.headDistal - pose2.torsoDistal);
if (any([e1, e2]))
    err(end+1) = mean([e1, e2]);
end
                
% Left shoulder
err(end+1)  = error_internal(pose1.upperLArmProximalEnabled, pose2.upperLArmProximalEnabled, ...
                    pose1.upperLArmProximal - pose1.torsoDistal, ...
                    pose2.upperLArmProximal - pose2.torsoDistal);           
% Left elbow
e1 = error_internal(pose1.upperLArmDistalEnabled, pose2.upperLArmDistalEnabled, ...
                    pose1.upperLArmDistal - pose1.torsoDistal, ...
                    pose2.upperLArmDistal - pose2.torsoDistal);
e2 = error_internal(pose1.lowerLArmProximalEnabled, pose2.lowerLArmProximalEnabled, ...
                    pose1.lowerLArmProximal - pose1.torsoDistal, ...
                    pose2.lowerLArmProximal - pose2.torsoDistal);
if (any([e1, e2]))
    err(end+1) = mean([e1, e2]);
end
% Left wrist
err(end+1)  = error_internal(pose1.lowerLArmDistalEnabled, pose2.lowerLArmDistalEnabled, ...
                    pose1.lowerLArmDistal - pose1.torsoDistal, ...
                    pose2.lowerLArmDistal - pose2.torsoDistal);

                
% Right shoulder 
err(end+1)  = error_internal(pose1.upperRArmProximalEnabled, pose2.upperRArmProximalEnabled, ...
                    pose1.upperRArmProximal - pose1.torsoDistal, ...
                    pose2.upperRArmProximal - pose2.torsoDistal);
% Right elbow 
e1 = error_internal(pose1.upperRArmDistalEnabled, pose2.upperRArmDistalEnabled, ...
                    pose1.upperRArmDistal - pose1.torsoDistal, ...
                    pose2.upperRArmDistal - pose2.torsoDistal);
e2 = error_internal(pose1.lowerRArmProximalEnabled, pose2.lowerRArmProximalEnabled, ...
                    pose1.lowerRArmProximal - pose1.torsoDistal, ...
                    pose2.lowerRArmProximal - pose2.torsoDistal);
if (any([e1, e2]))
    err(end+1) = mean([e1, e2]);
end
% Right wrist 
err(end+1)  = error_internal(pose1.lowerRArmDistalEnabled, pose2.lowerRArmDistalEnabled, ...
                    pose1.lowerRArmDistal - pose1.torsoDistal, ...
                    pose2.lowerRArmDistal - pose2.torsoDistal);


% Left hip
err(end+1)  = error_internal(pose1.upperLLegProximalEnabled, pose2.upperLLegProximalEnabled, ...
                    pose1.upperLLegProximal - pose1.torsoDistal, ...
                    pose2.upperLLegProximal - pose2.torsoDistal);
% Left knee
e1 = error_internal(pose1.upperLLegDistalEnabled, pose2.upperLLegDistalEnabled, ...
                    pose1.upperLLegDistal - pose1.torsoDistal, ...
                    pose2.upperLLegDistal - pose2.torsoDistal);
e2 = error_internal(pose1.lowerLLegProximalEnabled, pose2.lowerLLegProximalEnabled, ...
                    pose1.lowerLLegProximal - pose1.torsoDistal, ...
                    pose2.lowerLLegProximal - pose2.torsoDistal);
if (any([e1, e2]))
    err(end+1) = mean([e1, e2]);
end
% Left ankle 
err(end+1)  = error_internal(pose1.lowerLLegDistalEnabled, pose2.lowerLLegDistalEnabled, ...
                    pose1.lowerLLegDistal - pose1.torsoDistal, ...
                    pose2.lowerLLegDistal - pose2.torsoDistal);


% Right hip
err(end+1)  = error_internal(pose1.upperRLegProximalEnabled, pose2.upperRLegProximalEnabled, ...
                    pose1.upperRLegProximal - pose1.torsoDistal, ...
                    pose2.upperRLegProximal - pose2.torsoDistal);
% Right knee
e1 = error_internal(pose1.upperRLegDistalEnabled, pose2.upperRLegDistalEnabled, ...
                    pose1.upperRLegDistal - pose1.torsoDistal, ...
                    pose2.upperRLegDistal - pose2.torsoDistal);
e2 = error_internal(pose1.lowerRLegProximalEnabled, pose2.lowerRLegProximalEnabled, ...
                    pose1.lowerRLegProximal - pose1.torsoDistal, ...
                    pose2.lowerRLegProximal - pose2.torsoDistal);
if (any([e1, e2]))
    err(end+1) = mean([e1, e2]);
end
% Right ankle
err(end+1)  = error_internal(pose1.lowerRLegDistalEnabled, pose2.lowerRLegDistalEnabled, ...
                    pose1.lowerRLegDistal - pose1.torsoDistal, ...
                    pose2.lowerRLegDistal - pose2.torsoDistal);


% Head (top of the head)
err(end+1)  = error_internal(pose1.headProximalEnabled, pose2.headProximalEnabled, ...
                    pose1.headProximal - pose1.torsoDistal, ...
                    pose2.headProximal - pose2.torsoDistal);

                
err = mean(err); 



function [err] = error_internal(enable1, enable2, point1, point2)

if (enable1 && enable2)
    err = sqrt(sum((point1(:) - point2(:)).^2));
else
    err = [];
end


