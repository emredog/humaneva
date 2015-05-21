function [] = ComputeError2DExample()
% Example of how HumanEva-II dataset should be used to compute 2D error with
% validation data.
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


for SEQ = 1:length(CurrentDataset)
    fprintf('Loading sequence ... \n')
    fprintf('    Subject: %s \n', char(get(CurrentDataset(SEQ), 'SubjectName')));
    fprintf('    Action: %s \n',  char(get(CurrentDataset(SEQ), 'ActionType')));    
    fprintf('    Trial: %s \n\n',  char(get(CurrentDataset(SEQ), 'Trial')));
    fprintf('Using camera view %s.\n\n', CameraName);    
    
    % Get calibration filename
    DatasetBasePath = char(get(CurrentDataset(SEQ), 'DatasetBasePath'));
    Subject         = char(get(CurrentDataset(SEQ), 'SubjectName'));    
    CalibrationFilename   = [DatasetBasePath, Subject, '/Calibration_Data/', CameraName,  '.cal']; 

    % Load the sequence
    [ImageStream, ImageStream_Enabled, MocapStream, MocapStream_Enabled] ...
                            = sync_stream(CurrentDataset(SEQ));
    
    % Set frame range
    FrameStart = get(CurrentDataset(SEQ), 'FrameStart');
    FrameStart = [FrameStart{:}];
    FrameEnd   = get(CurrentDataset(SEQ), 'FrameEnd');    
    FrameEnd   = [FrameEnd{:}];
    
    for FRAME = FrameStart:FrameEnd
        fprintf('Loading video data for frame %d\n', FRAME);        
        if (ImageStream_Enabled(CAM))               
            [ImageStream(CAM), fname, image, map] = cur_image(ImageStream(CAM), FRAME);            
            fprintf('--> Use IMAGE from CAMERA (%s) to obtain the pose for the body using your algorithm\n', CameraName);
            % At this point IMAGE variable will contain the current image 
            % FRAME from camera CAM. 
        end            
        
        fprintf('Loading ground truth MoCap pose for frame %d\n', FRAME);

        if (MocapStream_Enabled)
            [MocapStream, groundTruthPose, ValidPose] = cur_frame(MocapStream, FRAME, 'body_pose');
            groundTruth2DPose = project2d(groundTruthPose, CalibrationFilename);
            
            if (ValidPose)                
                fprintf('--> Use computed by your algorithm pose to define BODY_POSE object HERE\n');
                
                customPose  = body_pose;
                custom2DPose = project2d(customPose, CalibrationFilename);
                % set(custom2DPose, 'torsoProximal', [1, 2]);  % 2D location of the joint
                % set(custom2DPose, 'torsoDistal',   [1, 2]);  % 2D location of the joint
                %         .
                %         .
                %         .
                % set(custom2DHead, 'torsoDistal',   [1, 2]);  % 2D location of the joint
                
                fprintf('Absolute error for frame %d is: %f (pix)\n', FRAME, error(groundTruth2DPose, custom2DPose));                    
                fprintf('Relative error for frame %d is: %f (pix)\n', FRAME, error_rel(groundTruth2DPose, custom2DPose));                    
                
            else
                warning('Mocap data is invalid');
            end
        end
        
        fprintf('    --- Press a key to continue to the next frame in the sequence ---    \n\n');
        pause;
    end
    
    fprintf('    --- Press a key to continue to the next validation sequence ---    \n');
    pause;

    fprintf('Close all the video streams\n');
    for CAM = 1:length(ImageStream)
        if (ImageStream_Enabled(CAM))
            pause(0.2);
            close(ImageStream);
        end
    end
end

