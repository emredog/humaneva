function [] = ShowPlacementOfMarkers()
% Example showing how the Proximal and Distal joints are defined in the
% BODY_POSE.
%
% Written by: Leonid Sigal 
% Revision:   1.1
% Date:       8/11/2007
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

% Add paths to the toolboxes
addpath('./TOOLBOX_calib/');
addpath('./TOOLBOX_common/');
addpath('./TOOLBOX_dxAvi/');
addpath('./TOOLBOX_readc3d/'); 

% Select the camera view
CAM = 1;

if (CAM == 1)
    CameraName = 'C1';
elseif (CAM == 2)
    CameraName = 'C2';    
elseif (CAM == 3)
    CameraName = 'C3';
elseif (CAM == 4)
    CameraName = 'C4';
end

% You can replace the 'Validate' by 'Train' or 'Test', to make this work
% on different sub-sets of data.
CurrentDataset = he_dataset('HumanEvaII', 'Test'); 

% Get calibration filename
SEQ = 1;
DatasetBasePath = char(get(CurrentDataset(SEQ), 'DatasetBasePath'));
Subject         = char(get(CurrentDataset(SEQ), 'SubjectName'));
CalibrationFilename   = [DatasetBasePath, Subject, '/Calibration_Data/', CameraName,  '.cal']; 

% Load the sequence
[ImageStream, ImageStream_Enabled, MocapStream, MocapStream_Enabled] ...
                        = sync_stream(CurrentDataset(SEQ));
      
    
FRAME = get(CurrentDataset(SEQ), 'FrameStart');
FRAME = [FRAME{:}];
if (ImageStream_Enabled(CAM))               
    [ImageStream(CAM), fname, image, map] = cur_image(ImageStream(CAM), FRAME);            
end            
        
if (MocapStream_Enabled)
    [MocapStream, groundTruthPose] = cur_frame(MocapStream, FRAME, 'body_pose');            
    groundTruth2DPose = project2d(groundTruthPose, CalibrationFilename);

    if (valid(groundTruthPose))                
        % Render joints (proximal)
        subplot(1,2,1);
        imshow(image);                
        hold on;
        plot([  groundTruth2DPose.torsoProximal(1)    , ... 
                groundTruth2DPose.upperLArmProximal(1), ...
                groundTruth2DPose.lowerLArmProximal(1), ...
                groundTruth2DPose.upperRArmProximal(1), ...
                groundTruth2DPose.lowerRArmProximal(1), ...
                groundTruth2DPose.upperLLegProximal(1), ...
                groundTruth2DPose.lowerLLegProximal(1), ...
                groundTruth2DPose.upperRLegProximal(1), ...
                groundTruth2DPose.lowerRLegProximal(1), ...
                groundTruth2DPose.headProximal(1)            ], ...
             [  groundTruth2DPose.torsoProximal(2)    , ... 
                groundTruth2DPose.upperLArmProximal(2), ...
                groundTruth2DPose.lowerLArmProximal(2), ...
                groundTruth2DPose.upperRArmProximal(2), ...
                groundTruth2DPose.lowerRArmProximal(2), ...
                groundTruth2DPose.upperLLegProximal(2), ...
                groundTruth2DPose.lowerLLegProximal(2), ...
                groundTruth2DPose.upperRLegProximal(2), ...
                groundTruth2DPose.lowerRLegProximal(2), ...
                groundTruth2DPose.headProximal(2)            ], ...
             'og', 'LineWidth', [2]);            
        hold off;
        text(groundTruth2DPose.torsoProximal(1)-20     ,groundTruth2DPose.torsoProximal(2)-20    , 'torso'    , 'Color', [1, 1, 0]);
        text(groundTruth2DPose.upperLArmProximal(1)+10 ,groundTruth2DPose.upperLArmProximal(2)-10, 'upperLArm', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.lowerLArmProximal(1)+10 ,groundTruth2DPose.lowerLArmProximal(2)+10, 'lowerLArm', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.upperRArmProximal(1)-120,groundTruth2DPose.upperRArmProximal(2)-10, 'upperRArm', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.lowerRArmProximal(1)-120,groundTruth2DPose.lowerRArmProximal(2)+10, 'lowerRArm', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.upperLLegProximal(1)+10 ,groundTruth2DPose.upperLLegProximal(2)-10, 'upperLLeg', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.lowerLLegProximal(1)+10 ,groundTruth2DPose.lowerLLegProximal(2)+10, 'lowerLLeg', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.upperRLegProximal(1)-120,groundTruth2DPose.upperRLegProximal(2)-10, 'upperRLeg', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.lowerRLegProximal(1)-120,groundTruth2DPose.lowerRLegProximal(2)+10, 'lowerRLeg', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.headProximal(1)-20      ,groundTruth2DPose.headProximal(2)-20     , 'head'     , 'Color', [1, 1, 0]);
        title('Proximal Markers');

        % Render joints (distal)    
        subplot(1,2,2);
        imshow(image);                
        hold on;
        plot([  groundTruth2DPose.torsoDistal(1)      , ...
                groundTruth2DPose.upperLArmDistal(1)  , ...
                groundTruth2DPose.lowerLArmDistal(1)  , ...
                groundTruth2DPose.upperRArmDistal(1)  , ...
                groundTruth2DPose.lowerRArmDistal(1)  , ...
                groundTruth2DPose.upperLLegDistal(1)  , ...
                groundTruth2DPose.lowerLLegDistal(1)  , ...
                groundTruth2DPose.upperRLegDistal(1)  , ...
                groundTruth2DPose.lowerRLegDistal(1)  , ...
                groundTruth2DPose.headDistal(1)            ], ...
             [  groundTruth2DPose.torsoDistal(2)      , ...
                groundTruth2DPose.upperLArmDistal(2)  , ...
                groundTruth2DPose.lowerLArmDistal(2)  , ...
                groundTruth2DPose.upperRArmDistal(2)  , ...
                groundTruth2DPose.lowerRArmDistal(2)  , ...
                groundTruth2DPose.upperLLegDistal(2)  , ...
                groundTruth2DPose.lowerLLegDistal(2)  , ...
                groundTruth2DPose.upperRLegDistal(2)  , ...
                groundTruth2DPose.lowerRLegDistal(2)  , ...
                groundTruth2DPose.headDistal(2)              ], ...                        
             'om', 'LineWidth', [2]);                                      
        hold off;
        text(groundTruth2DPose.torsoDistal(1)-20     ,groundTruth2DPose.torsoDistal(2)-20    , 'torso'    , 'Color', [1, 1, 0]);
        text(groundTruth2DPose.upperLArmDistal(1)+10 ,groundTruth2DPose.upperLArmDistal(2)-10, 'upperLArm', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.lowerLArmDistal(1)+10 ,groundTruth2DPose.lowerLArmDistal(2)+10, 'lowerLArm', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.upperRArmDistal(1)-120,groundTruth2DPose.upperRArmDistal(2)-10, 'upperRArm', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.lowerRArmDistal(1)-120,groundTruth2DPose.lowerRArmDistal(2)+10, 'lowerRArm', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.upperLLegDistal(1)+10 ,groundTruth2DPose.upperLLegDistal(2)-10, 'upperLLeg', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.lowerLLegDistal(1)+10 ,groundTruth2DPose.lowerLLegDistal(2)+10, 'lowerLLeg', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.upperRLegDistal(1)-120,groundTruth2DPose.upperRLegDistal(2)-10, 'upperRLeg', 'Color', [1, 1, 0]);
        text(groundTruth2DPose.lowerRLegDistal(1)-120,groundTruth2DPose.lowerRLegDistal(2)+10, 'lowerRLeg', 'Color', [1, 1, 0]);        
        text(groundTruth2DPose.headDistal(1)-20      ,groundTruth2DPose.headDistal(2)-20     , 'head'     , 'Color', [1, 1, 0]);         
        title('Distal Markers');
        set(gcf, 'Color', [0.5, 0.5, 0.5]);
    else
        warning('Mocap data is invalid');
    end
end
    
fprintf('Close all the video streams\n');
for CAM = 1:length(ImageStream)
    if (ImageStream_Enabled(CAM))
        pause(0.2);
        close(ImageStream);
    end
end

