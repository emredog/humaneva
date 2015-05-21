function [] = BackgroundSubtraction(min_area, one_comp, risk)
% Example code for computing background subtraction images for the HumanEva 
% dataset. Each pixel is modeled as a mixture of Gaussian distributions. 
% Three sets of background images were collected at the beginning, middle, 
% and end of a week-long capture session during which HumanEva dataset
% was collected. In each set, we assume that each pixel can be modeled 
% using a diagonal covariance Gaussian distribution. This results in a 
% 3-component mixture distribution (one for each set) for the background 
% model. Assuming that the distribution over foreground is uniform, we 
% obtain the following classification criterion for each pixel:
%
%       N(pix, mean, sigma) < ( 1/(256*256*256) ), where 
%     
%               pix   = [pix_r, pix_g, pix_b],
%               mean  = [pix_r, pix_g, pix_b],
%               sigma = eye([sigma_r, sigma_g, sigma_b]).
%
% This criterion has been modified slightly to include the risk of the
% misclassification as follows:
%
%       N(pix, mean, sigma) < ( 1/(256*256*256*thr) ).
%
% Two sets of optional post-processing routines are implemented based on 
% the connected component analysis. First, connected components that are 
% bellow some threshold in size can be filtered out. Second, all but the
% largest connected component can be filtered out.
%
% Syntax: 
%       [] = BackgroundSubtraction();
%       [] = BackgroundSubtraction(min_area);
%       [] = BackgroundSubtraction(min_area, one_comp);
%       [] = BackgroundSubtraction(min_area, one_comp, risk);
%
% Variables:    
%   min_area   - this positive integer parameter will ensure that all 
%                connected components that are < min_area in pixels are 
%                filtered out (by default 10).
%   one_comp   - boolean allows the filtering of all but one largest 
%                connected component (by default disabled, 0).
%   risk       - 1x7 or 7x1 vector of relative risk of miss-classification 
%                (default [1,1,1,1,1,1,1]).
%
% Note:
%   We found that reasonable results for the background subtraction using
%   default values of all parameters can be obtained for subjects S2, S3,
%   and S4. Relatively poor results were observed for gray-scale camera 
%   data for subject S1. Somewhat more gracious background subtraction for
%   S1 can be obtained by adjusting the risk to 
%            risk = [1, 1, 1, 10^60, 10^60, 10^60, 10^100];
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
% 

if (nargin == 0)
    min_area = 10;
    one_comp = 0; 
    risk     = [1, 1, 1, 1, 1, 1, 1]; 
    risk     = [10^80, 10^60, 10^30, 10^80];
end

if (nargin == 1)
    one_comp = 0; 
    risk     = [1, 1, 1, 1, 1, 1, 1]; 
    risk     = [10^80, 10^60, 10^30, 10^80];
end

if (nargin == 2)
    risk     = [1, 1, 1, 1, 1, 1, 1]; 
    risk     = [10^80, 10^60, 10^30, 10^80];
end
    
% Add paths to the toolboxes
addpath('./TOOLBOX_calib/');
addpath('./TOOLBOX_common/');
addpath('./TOOLBOX_dxAvi/');
addpath('./TOOLBOX_readc3d/'); 

        

% Load HumanEva dataset 
CurrentDataset = he_dataset('HumanEvaII', 'Test'); 

% Perform background subtraction
for SEQ = 1:length(CurrentDataset)
    Subject     = char(get(CurrentDataset(SEQ), 'SubjectName'));
    DatasetPath = char(get(CurrentDataset(SEQ), 'DatasetBasePath'));
    
    fprintf('Loading sequence ... \n')
    fprintf('    Subject: %s \n', Subject);
    fprintf('    Action: %s \n',  char(get(CurrentDataset(SEQ), 'ActionType')));    
    fprintf('    Trial: %s \n\n',  char(get(CurrentDataset(SEQ), 'Trial')));
        
    
    % Path for backgound images
    BG_PATH = [DatasetPath '/' Subject '/Background/'];

    % Compute background statistics. This generally will take a while to run 
    % (up to 24 hours), but only needs to be done once. 
    for CAM = 1:4
        fprintf('Computing background statistics for CAM %d.\n', CAM)
        savefilename = [BG_PATH 'Background_(C' num2str(CAM) ').mat'];

        if (~exist(savefilename))
            sum_of_squares = {};
            sum_of_values = {};
            bg_means = {};
            bg_vars  = {};

            % filelist = dir([BG_PATH 'Background_*_(C' num2str(CAM) ').avi']);
            filelist = dir([BG_PATH 'Background_*_(C' num2str(CAM) ')']);

            total_frames = zeros(size(filelist));

            % Over all images from a sequence compute the sufficient statistics
            % (that is sum of values for all pixels, and sum of squares). 
            for F = 1:length(filelist)
                % filename = [BG_PATH '/' filelist(F).name];
                filename = [BG_PATH '/' filelist(F).name '/'];
                fprintf('Processing filename %s.\n', filename);

                IM_STREAM = image_stream(filename, 1);

                fprintf('  frame number %.4d/%.4d', 0, n_frames(IM_STREAM));
                for frame_num = 1:n_frames(IM_STREAM)
                    [this, fname, img, map] = cur_image(IM_STREAM,  frame_num);
                    fprintf('\b\b\b\b\b\b\b\b\b%.4d/%.4d', frame_num, n_frames(IM_STREAM));

                    if (frame_num == 1)
                        sum_of_values{F}  = img;
                        sum_of_squares{F} = img.^2;
                        total_frames(F)   = 1;
                    else
                        sum_of_values{F}  = sum_of_values{F} + img;
                        sum_of_squares{F} = sum_of_squares{F} + img.^2;
                        total_frames(F)   = total_frames(F) + 1;
                    end
                end
                fprintf('\n');

                close(IM_STREAM);

                % compute statistics
                bg_means{F} = sum_of_values{F} / total_frames(F);
                bg_vars{F}  = sum_of_squares{F} / total_frames(F) - (sum_of_values{F} / total_frames(F)).^2;    

                % if pixel has no variance (e.g. saturated in all frames) then
                % assign a reasonable variance.
                ind = find(bg_vars{F} == 0.0);
                bg_vars{F}(ind) = 1.0000e-003;        
            end

            % Save the result in a file.
            save(savefilename, 'bg_means', 'bg_vars', '-MAT');
            fprintf('  (done).\n')
        else
            fprintf('  (already pre-computed).\n')
        end
    end


    % Load background statistics
    for CAM = 1:4
        fprintf('Loading background statistics for CAM %d.\n', CAM)    
        loadfilename = [BG_PATH 'Background_(C' num2str(CAM) ').mat'];
        load(loadfilename);
        background(CAM).CameraName          = sprintf('C%d', CAM);
        background(CAM).BackgroundMeans     = bg_means;
        background(CAM).BackgroundVariances = bg_vars;     
    end
    
    
    % Load the sequence
    [ImageStream, ImageStream_Enabled, MocapStream, MocapStream_Enabled] ...
                            = sync_stream(CurrentDataset(SEQ));
      
    Nframes = min([n_frames(ImageStream), n_frames(MocapStream)]);    
    for FRAME = 1:100:Nframes
        for CAM = 1:length(ImageStream)
            subplot(2, 4, CAM);
            if (ImageStream_Enabled(CAM))               
                % Load image from the video stream
                [ImageStream(CAM), fname, image, map] = cur_image(ImageStream(CAM), FRAME);            
                
                % Compute per-pixel probability that it belongs to
                % background
                bg_prob = zeros(size(image,1), size(image,2));
                for M = 1:length(background(CAM).BackgroundMeans)       
                    bg_prob = bg_prob ...
                                + 1/length(bg_means) ...
                                * prod(normpdf(image, ...
                                               background(CAM).BackgroundMeans{M}, ...
                                          sqrt(background(CAM).BackgroundVariances{M})),3);     
                end
                % Classify pixel based on the assumption that foreground
                % is distributed according to uniform distribution.
                bg_img = double(bg_prob < 1/(256*256*256*risk(CAM)));
                
                % Filter out all but the largest connected component
                if (one_comp)
                    [L] = bwlabel(bg_img);
                    reg = regionprops (L,'Area');
                    L_selected = find([reg.Area] == max([reg.Area]));
                    bg_img(find(L ~= L_selected)) = 0;
                end
                                        
                % Filter out all connected component area of which is less
                % then min_area
                if (min_area > 0)
                    [L] = bwlabel(bg_img, 4);
                    reg = regionprops (L,'Area');
                    L_selected = find([reg.Area] < min_area);
                    bg_img(find(ismember(L, L_selected))) = 0;
                end

                % Display resulting binary background subtraction image
                imshow(bg_img);                
                title(sprintf('Camera C%d', CAM));
            end              
            pause(0.1);
        end
        pause;
    end    
    
    % Close all video streams
    for I = 1:length(ImageStream)
        if (ImageStream_Enabled)
            close(ImageStream);
        end
    end
end


