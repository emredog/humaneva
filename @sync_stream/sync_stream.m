function [ImageStream, ImageStream_Enabled, MocapStream, MocapStream_Enabled] ...
        = sync_stream(file_c3d, file_c3d_st, file_mp, image_paths, file_ofs)
% SYNC_STREAM Object handels synchronization between the MOCAP and Image
%             data.
%
% Format:
%   [ImageStream, ImageStrean_Enabled, MocapStream, MocapStream_Enabled] =
%                   SYNC_STREAM(Dataset)
%   [ImageStream, ImageStrean_Enabled, MocapStream, MocapStream_Enabled] =
%                   SYNC_STREAM(FileC3D, FileMP, ImagePaths, FileOFS)
%
% Input:
%   Dataset     - Object of type DATASET.
%   FileC3D     - Filename of the Motion Capture (MoCap) data (.C3D file) 
%   FileMP      - Filename of the MoCap subject data (.MP file) 
%   FileC3D_ST  - Filename of the static Motion Capture (MoCap) data trial 
%                 (.C3D file) 
%   ImagePaths  - Cell array of filenames for image (Video) data. You can
%                 either supply a full path to the directory that contains
%                 sequenced BMPs, or a full path (including the filename) 
%                 for the AVI files. 
%                 length(IMAGE_PATHS) == N, where N is the number of 
%                 synchronious image streams                  
%   FileOFS     - Cell array of filenames for the .OFS (synchronization
%                 files). 
%                 length(FILE_OFS) == N, where N is the number of 
%                 synchronious image streams                  
%
% Output: 
%   ImageStream - Array of IMAGE_STREAM objects of size 1xN. 
%   ImageStrean_Enabled 
%               - Array of booleans of size 1xN designating if the 
%                 corresponding IMAGE_STREAM objects are valid. 
%   MocapStream - MOCAP_STREAM object that by a virtue of the SYNC_STREAM
%                 is synchronized with IMAGE_STREAM(s) above.
%   MocapStream_Enabled 
%               - Boolean designating if the MOCAP_STREAM object is valid.
%
% Example:
%
%   % Mocap filename 
%   FileC3D    = '../S1/Mocap_Data/Walking_1.c3d';

%   % Mocap filename 
%   FileC3D_ST = '../S1/Mocap_Data/Static.c3d';
%
%   % Mocap filename 
%   FileMP     = '../S1/Mocap_Data/S1.mp';
%
%   % Image filenames
%   ImagePaths{1} = '../S1/Image_Data/Walking_1_(BW1).avi';
%   ImagePaths{2} = '../S1/Image_Data/Walking_1_(BW2).avi';
%   ImagePaths{3} = '../S1/Image_Data/Walking_1_(BW3).avi';
%   ImagePaths{4} = '../S1/Image_Data/Walking_1_(BW4).avi';
%   ImagePaths{5} = '../S1/Image_Data/Walking_1_(C1).avi';
%   ImagePaths{6} = '../S1/Image_Data/Walking_1_(C2).avi';
%   ImagePaths{7} = '../S1/Image_Data/Walking_1_(C3).avi';
%
%   % Sync filenames
%   FileOFS{1} = '../S1/Sync_Data/Walking_1_(BW1).ofs';
%   FileOFS{2} = '../S1/Sync_Data/Walking_1_(BW2).ofs';
%   FileOFS{3} = '../S1/Sync_Data/Walking_1_(BW3).ofs';
%   FileOFS{4} = '../S1/Sync_Data/Walking_1_(BW4).ofs';
%   FileOFS{5} = '../S1/Sync_Data/Walking_1_(C1).ofs';
%   FileOFS{6} = '../S1/Sync_Data/Walking_1_(C2).ofs';
%   FileOFS{7} = '../S1/Sync_Data/Walking_1_(C3).ofs';
%   
%   [IS, IS_Valid, MS, MS_Valid] = sync_stream(FileC3D, FileC3D_ST, FileMP,
%                                               ImagePaths, FileOFS);
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

if ((nargin == 1) && isa(file_c3d, 'he_dataset'))
    CurrentDataset = file_c3d;
    
    DatasetBasePath = char(get(CurrentDataset, 'DatasetBasePath'));
    Subject         = char(get(CurrentDataset, 'SubjectName'));
    Action          = char(get(CurrentDataset, 'ActionType'));
    Trial           = char(get(CurrentDataset, 'Trial'));
    FrameStart      = get(CurrentDataset, 'FrameStart');
    FrameStart      = [FrameStart{:}];
    FrameEnd        = get(CurrentDataset, 'FrameEnd');
    FrameEnd        = [FrameEnd{:}];
                        
    % Setup full path references to the offset and image files
    numCams = length(dir([DatasetBasePath, Subject, '/Sync_Data/', Action, '_' , ...
                              Trial, '_(*).ofs']));

    % HumanEvaI
    if (numCams == 7)
        for CAM = 1:3 
            file_ofs{CAM}      = [DatasetBasePath, Subject, '/Sync_Data/', Action, '_' , ...
                                  Trial, '_(C' num2str(CAM) ').ofs'];
            if (exist([DatasetBasePath, Subject, '/Image_Data/', Action, '_' , Trial, '_(C' num2str(CAM) ')/']))
                image_paths{CAM}   = [DatasetBasePath, Subject, '/Image_Data/', Action, '_' , ...
                                      Trial, '_(C' num2str(CAM) ')/'];                
            else
                image_paths{CAM}   = [DatasetBasePath, Subject, '/Image_Data/', Action, '_' , ...
                                      Trial, '_(C' num2str(CAM) ').avi'];
            end
        end
        for CAM = 1:4
            file_ofs{CAM+3}    = [DatasetBasePath, Subject, '/Sync_Data/', Action, '_' , ...
                                  Trial, '_(BW' num2str(CAM) ').ofs'];
            if (exist([DatasetBasePath, Subject, '/Image_Data/', Action, '_' , Trial, '_(BW' num2str(CAM) ')/']))
                image_paths{CAM+3} = [DatasetBasePath, Subject, '/Image_Data/', Action, '_' , ...
                                      Trial, '_(BW' num2str(CAM) ')/'];
            else
                image_paths{CAM+3} = [DatasetBasePath, Subject, '/Image_Data/', Action, '_' , ...
                                      Trial, '_(BW' num2str(CAM) ').avi'];
            end
        end 
    end

    % HumanEvaII
    if (numCams == 4) 
        for CAM = 1:4
            file_ofs{CAM}    = [DatasetBasePath, Subject, '/Sync_Data/', Action, '_' , ...
                                  Trial, '_(C' num2str(CAM) ').ofs'];
            if (exist([DatasetBasePath, Subject, '/Image_Data/', Action, '_' , Trial, '_(C' num2str(CAM) ')/']))
                image_paths{CAM} = [DatasetBasePath, Subject, '/Image_Data/', Action, '_' , ...
                                      Trial, '_(C' num2str(CAM) ')/'];
            else
                image_paths{CAM} = [DatasetBasePath, Subject, '/Image_Data/', Action, '_' , ...
                                      Trial, '_(C' num2str(CAM) ').avi'];                
            end
        end
    end
    
    % Setup full path to the static C3D MoCap data
    file_c3d_st  = [DatasetBasePath, Subject, '/Mocap_Data/Static.c3d']; 
    % Setup full path to the subject measurement data
    file_mp  = [DatasetBasePath, Subject, '/Mocap_Data/', Subject, '.mp']; 
    % Setup full path to the dynamic C3D MoCap data (the actual motion data)
    file_c3d = [DatasetBasePath, Subject, '/Mocap_Data/', Action, '_', Trial, '.c3d'];    
else
    error(nargchk(5, 5, nargin));
end


% Load stream offset info (OFS files)
for I = 1:length(file_ofs) 
    % filename of the OFS file 
    ofsfilename = file_ofs{I};
    try 
        % read the OFS file 
        [im_st, mc_st, mc_sc] = ReadStreamOffset(ofsfilename);

        % compute the common offset and scaling for all the streams
        if ((I == 1) || (sum(ImageStream_Enabled) == 0))
            common_time    = mc_st;
            common_scaling = mc_sc;
            start_image_offset(I) = im_st;         
        else
            start_image_offset(I) = im_st + (common_time - mc_st) / mc_sc;
            common_scaling        = common_scaling + mc_sc;
        end
        ImageStream_Enabled(I) = 1;
    catch
        start_image_offset(I)  = 1000000; 
        ImageStream_Enabled(I) = 0;
        warning('Offset file is missing');
    end
end
if (sum(ImageStream_Enabled) > 0)
    common_scaling     = common_scaling / sum(ImageStream_Enabled);
    common_time        = common_time - common_scaling * (min(start_image_offset) - 1);
    start_image_offset = start_image_offset - min(start_image_offset) + 1;
    if (common_time < 1)
       start_image_offset = start_image_offset - (common_time - 1) / common_scaling ;
       common_time        = common_time - common_time + 1;
    end
    start_image_offset = round(start_image_offset);
else
    common_scaling     = 1.0; 
    common_time        = 1.0;
    start_image_offset = 1.0;    
end

% If there are any valid image streams, create the stream objects to access 
% the image data.
for I = 1:length(ImageStream_Enabled)
    if (ImageStream_Enabled(I))
        ImageStream(I) = image_stream(image_paths{I}, start_image_offset(I));
    else
        ImageStream(I) = image_stream;
    end
end

% Create a mocap stream, if the data is valid and available. 
if (exist(file_c3d))
    %try 
        MocapStream = mocap_stream(file_c3d, file_c3d_st, file_mp, common_time, common_scaling);
        MocapStream_Enabled = 1;
    %catch
    %    MocapStream = mocap_stream;
    %    MocapStream_Enabled = 0;    
    %end
else
    MocapStream = mocap_stream;
    MocapStream_Enabled = 0;        
end
