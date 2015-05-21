function [this] = image_stream(img_base, offset);
% IMAGE_STREAM Object handels image/video stream data.
%
% Format:
%   [THIS] = image_stream(FILENAME, OFFSET);
%
% Input:
%   FILENAME    - Filename of the image or video data. FILENAME is a string
%                 containing a full path to the directory containing 
%                 sequenced BMPs, or full path to AVI file.
%   OFFSET      - Optinal stream offset in frames (default OFFSET = 0).
%
% Output: 
%   THIS        - IMAGE_STREAM object.
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

s = struct('mode', 'sequenced images', ....
           'start_filename', '', ... 
           'end_filename', '', ...
           'stream_offset', 0, ...  
           'stream_scaling', 1, ...
           'current_position', 0, ...
           'avi_hdl', 0, ...
           'avi_info', '');       

if (nargin == 0)
    this = class(s, 'image_stream');
    return;    
end

if (nargin == 1) 
    if (isa(img_base, 'image_stream'))
        this = img_base;
        return;
    else        
        offset = 0;        
    end
end
    

if (ischar(img_base))
    if ((exist(img_base) ~= 7) && (exist(img_base) ~= 2))
        error('First argument to "image_base" must be a valid path or AVI file.');        
    end    
else
    error('First argument to "image_stream" must be a valid path, that contains image files.');
end

% select the mode
if ((exist(img_base) == 7))
    s.mode = 'sequenced images';
end
if ((exist(img_base) == 2))
    s.mode = 'video';
end

if (strcmp(s.mode, 'sequenced images'))
    % Actually do the processing
    filenames = dir([img_base '*.bmp']);
    if (size(filenames, 1) == 0)
        filenames = dir([img_base '*.png']);
    end
    if (size(filenames, 1) == 0)
        filenames = dir([img_base '*.tif']);
    end
    if (size(filenames, 1) == 0)
        filenames = dir([img_base '*.tiff']);
    end
    if (size(filenames, 1) == 0)
        error('No files of appropriate image format are found.');            
    end
    
    % Start file counter for Spica data
    start_file.bn   = '';
    start_file.lz   = 0;
    start_file.fcnt = inf;
    start_file.ext  = '';
    
    end_file.bn     = '';
    end_file.lz     = 0;
    end_file.fcnt   = -inf;
    end_file.ext    = '';
    
    for J = 1:size(filenames,1)
        [bn, lz, fcnt, ext] = FilenameParse(filenames(J).name);
        if (fcnt < start_file.fcnt)
            start_file.bn   = [img_base bn];
            start_file.lz   = lz;
            start_file.fcnt = fcnt;
            start_file.ext  = ext;
        end
        if (fcnt > end_file.fcnt)
            end_file.bn     = [img_base bn];
            end_file.lz     = lz;
            end_file.fcnt   = fcnt;
            end_file.ext    = ext;
        end
    end     
    
    s.start_filename = start_file;
    s.end_filename   = end_file;
    s.stream_offset  = offset;
    s.stream_scaling = 1;    
end

if (strcmp(s.mode, 'video'))
    s.start_filename = img_base;
    s.end_filename   = img_base;
    s.stream_offset  = offset;    
    s.stream_scaling = 1;    
    [s.avi_hdl, s.avi_info] = dxAviOpen(img_base);	
end

this = class(s, 'image_stream');




function [basename, leadzeros, filecounter, extention] = FilenameParse(filename)

N = prod(size(filename));

ind = findstr('.', filename);
ind = ind(prod(size(ind)));
extention = filename(ind+1:N);

stil_number = 1;
for I=ind-1:-1:1
    if (stil_number)
        if (isempty(str2num(filename(I:ind-1))))
            stil_number = 0;
            basename = filename(1:I);
            filecounter = str2num(filename(I+1:ind-1));
        end
    end
end

leadzeros = N - prod(size(extention)) - 1  ... 
              - prod(size(num2str(filecounter))) ...
              - prod(size(basename));

          
