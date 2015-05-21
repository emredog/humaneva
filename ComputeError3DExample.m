function [] = ComputeError3DExample()
% Example of how HumanEva-II dataset should be used to compute 3D error with
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

% You can replace the 'Validate' by 'Train' or 'Test', to make this work
% on different sub-sets of data.
CurrentDataset = he_dataset('HumanEvaII', 'Test'); 

for SEQ = 1:length(CurrentDataset)
    fprintf('Loading sequence ... \n')
    fprintf('    Subject: %s \n', char(get(CurrentDataset(SEQ), 'SubjectName')));
    fprintf('    Action: %s \n',  char(get(CurrentDataset(SEQ), 'ActionType')));    
    fprintf('    Trial: %s \n\n',  char(get(CurrentDataset(SEQ), 'Trial')));

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
        for CAM = 1:length (ImageStream)
            if (ImageStream_Enabled(CAM))               
                [ImageStream(CAM), fname, image, map] = cur_image(ImageStream(CAM), FRAME);            
                fprintf('--> Use IMAGE from CAMERA %d to obtain the pose for the body using your algorithm\n', CAM);
                % At this point IMAGE variable will contain the current image 
                % FRAME from camera CAM. You can load images from all views
                % and then pass it to your algorithm after this loop for
                % computing the pose.
                %
                %           e.g. multiviewFrame{CAM} = image; 
            end            
        end
        % Call to the 3D pose/tracking function here 
        %           e.g. ComputePose(multiviewFrame);
        
        fprintf('Loading ground truth MoCap pose for frame %d\n', FRAME);

        if (MocapStream_Enabled)
            [MocapStream, groundTruthPose, ValidPose] = cur_frame(MocapStream, FRAME, 'body_pose');

            if (ValidPose)
                fprintf('--> Use computed by your algorithm pose to define BODY_POSE object HERE\n');
                
                customPose  = body_pose;
                % set(customPose, 'torsoProximal', [1, 2, 3]);  % 3D location of the joint
                % set(customPose, 'torsoDistal',   [1, 2, 3]);  % 3D location of the joint
                %         .
                %         .
                %         .
                % set(customHead, 'torsoDistal',   [1, 2, 3]);  % 3D location of the joint

                fprintf('Absolute error for frame %d is: %f (mm)\n', FRAME, error(groundTruthPose, customPose));                    
                fprintf('Relative error for frame %d is: %f (mm)\n', FRAME, error_rel(groundTruthPose, customPose));                    
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
