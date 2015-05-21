function [this] = mocap_stream(file_c3d, file_c3d_st, file_mp, offset, scaling);
% MOCAP_STREAM Object handels motion capture stream data.
%
% Syntax:
%   [THIS] = mocap_stream(FILE_C3D, FILE_C3D_ST, FILE_MP);
%   [THIS] = mocap_stream(FILE_C3D, FILE_C3D_ST, FILE_MP, OFFSET);
%   [THIS] = mocap_stream(FILE_C3D, FILE_C3D_ST, FILE_MP, OFFSET, SCALING);
%
% Input:
%   FILE_C3D    - Filename of the motion capture data. FILE_C3D is 
%                 a string containing a full path to the .C3D file. 
%   FILE_C3D_ST - Filename of the static motion capture trial. FILE_C3D_ST 
%                 is a string containing a full path to the .C3D file. 
%   FILE_MP     - Filename of the MoCap subject data file. FILE_MP is 
%                 a string containing a full path to the .MP file.
%   OFFSET      - Optional stream offset in frames (default OFFSET = 0).
%   SCALING     - Optional stream scaling in frames (default OFFSET = 1). 
%                 Scaling can and often is fractional. Since motion
%                 capture is often captured at 120 Htz and video at 60 Htz,
%                 this parameter will often be close to 2.
%
% Output: 
%   THIS        - MOCAP_STREAM object.
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

d = struct('Markers', [], ... 
           'VideoFrameRate', [], ...
           'AnalogSignals', [], ...
           'AnalogFrameRate', [], ...
           'Event', [], ...
           'ParameterGroup', [], ...
           'CameraInfo', [], ...
           'ResidualError', []);      

s = struct('filename', '', ...
           'stream_offset', 0, ...
           'stream_scaling', 1, ...
           'current_position', 0, ...
           'data', d, ...
           'static', d, ...
           'Params', []);
           
if (nargin == 0)
    this = class(s, 'mocap_stream');
    return;
end

if (nargin == 1)
    if (isa(file_c3d, 'mocap_stream'))
        this = file_c3d;
        return;
    else
        error('Function requires different parameters.');
    end
end

if (nargin < 3)
    error('Function requires at least 2 parameters.');    
end

if (nargin < 4)
    offset = 0;
end

if (nargin < 5)
    scaling = 1;
end
    
s.filename       = file_c3d;
s.stream_offset  = offset;
s.stream_scaling = scaling;
                   
if (exist([file_c3d(1:end-4) '.mat']))
    % load MAT file 
    load([file_c3d(1:end-4) '.mat']);
    
    % check that marker data is present
    if (exist('Markers'))
        s.data.Markers = Markers;
    else
        error('Marker data must be present in the MAT file.');
    end
    
    % check that parameter group data is present
    if (exist('ParameterGroup'))
        s.data.ParameterGroup = ParameterGroup;
    else
        error('Marker data must be present in the MAT file.');
    end    

    % assign all other possible data
    if (exist('VideoFrameRate'))
        s.data.VideoFrameRate = VideoFrameRate;
    end
    if (exist('AnalogSignals'))    
        s.data.AnalogSignals = AnalogSignals;
    end           
    if (exist('AnalogFrameRate'))    
        s.data.AnalogFrameRate = AnalogFrameRate;
    end
    if (exist('Event'))    
        s.data.Event = Event;
    end
    if (exist('CameraInfo'))    
        s.data.CameraInfo = CameraInfo;
    end
    if (exist('ResidualError'))    
        s.data.ResidualError = ResidualError;
    end
else
    [Markers, VideoFrameRate, AnalogSignals, AnalogFrameRate, ...
        Event, ParameterGroup, CameraInfo, ResidualError] = readc3d(file_c3d);   
    
    save([file_c3d(1:end-4) '.mat'], ...
         'Markers', 'VideoFrameRate', 'AnalogSignals', 'AnalogFrameRate', ...
         'Event', 'ParameterGroup', 'CameraInfo', 'ResidualError', '-MAT');
    
    s.data.Event            = Event;
    s.data.Markers          = Markers;
    s.data.CameraInfo       = CameraInfo;
    s.data.ResidualError    = ResidualError;    
    s.data.AnalogSignals    = AnalogSignals;
    s.data.ParameterGroup   = ParameterGroup;
    s.data.VideoFrameRate   = VideoFrameRate;
    s.data.AnalogFrameRate  = AnalogFrameRate;
end

if (exist([file_c3d_st(1:end-4) '.mat']))
    % load MAT file 
    load([file_c3d_st(1:end-4) '.mat']);
    
    s.static.Event            = Event;
    s.static.Markers          = Markers;
    s.static.CameraInfo       = CameraInfo;
    s.static.ResidualError    = ResidualError;    
    s.static.AnalogSignals    = AnalogSignals;
    s.static.ParameterGroup   = ParameterGroup;
    s.static.VideoFrameRate   = VideoFrameRate;
    s.static.AnalogFrameRate  = AnalogFrameRate;    
else
    [Markers, VideoFrameRate, AnalogSignals, AnalogFrameRate, ...
        Event, ParameterGroup, CameraInfo, ResidualError] = readc3d(file_c3d_st);   
    
    save([file_c3d_st(1:end-4) '.mat'], ...
         'Markers', 'VideoFrameRate', 'AnalogSignals', 'AnalogFrameRate', ...
         'Event', 'ParameterGroup', 'CameraInfo', 'ResidualError', '-MAT', '-V6');

    s.static.Event            = Event;
    s.static.Markers          = Markers;
    s.static.CameraInfo       = CameraInfo;
    s.static.ResidualError    = ResidualError;    
    s.static.AnalogSignals    = AnalogSignals;
    s.static.ParameterGroup   = ParameterGroup;
    s.static.VideoFrameRate   = VideoFrameRate;
    s.static.AnalogFrameRate  = AnalogFrameRate;    
end
s.Params = ComputeLimbParameters(Markers, ParameterGroup, file_mp);

this = class(s, 'mocap_stream');