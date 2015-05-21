function [n] = n_frames(this)
% N_FRAMES Accesor function allows determening the number of frames in the
%          stream object IMAGE_STREAM.
%
% Syntax:
%   [N] = n_frames(THIS);
%
% Input:
%   THIS        - IMAGE_STREAM object, or array of objects. All objects
%                 must be valid.
%
% Output: 
%   N           - Number of frames in the IMAGE_STREAM object. If a number
%                 of IMAGE_STREAMs are supplied, the function assumes that
%                 streams are synchronized and returns the common portion
%                 of frames available from all the streams (i.e. minimum
%                 over all numbers of frames in each individual 
%                 IMAGE_STREAM).
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

if (length(this(:)) > 1)
    for I = 1:length(this(:))
        n(I) = n_frames(this(I)); 
    end    
    n = min(n);
else    
    if (strcmp(this.mode, 'sequenced images'))   
        n = (this.end_filename.fcnt - this.start_filename.fcnt) - this.stream_offset;
    end

    if (strcmp(this.mode, 'video'))
        fileinfo = aviinfo(this.start_filename);
        n = fileinfo.NumFrames - this.stream_offset;
    end

    n = n / this.stream_scaling;
end