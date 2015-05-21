function [] = visualize(this, step, p)
% VISUALIZE Display for the stream object IMAGE_STREAM.
%
% Syntax:
%   [] = visualize(THIS, STEP, P);
%
% Input:
%   THIS        - IMAGE_STREAM object, or array of objects. All objects
%                 must be valid.
%   STEP        - Optinal parameter specifying the number of frames to 
%                 skip between the frames shown.
%   P           - Optional boolean parameter designating if there should
%                 be a pause between the frames shown.
%
% Output: 
%   Figure displaying the image streams synchroniously (if there are more
%   then one). Each stream is displayed in the sub-plot. The sub-plot 
%   layout will be set according to the layout of the THIS variable
%   supplied.
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

if (nargin < 3)    
    p = 0;
end

if (nargin > 1)
    if ((step < 1) || (round(step) ~= step))
        error('Step size is inapropriate');
    end
    
    for I = 1:size(this,1)
        for J = 1:size(this,2)
            this(I,J).stream_scaling = step; 
        end
    end
end

N = n_frames(this);
for F = 1:N
    for I = 1:size(this,1)
        for J = 1:size(this,2)
            [this(I,J), fname, img] = cur_image(this(I,J), F);
            subplot(size(this,1), size(this,2), sub2ind(size(this),I,J)); 
            imshow(img);
        end
    end

    if (p == 1);
        pause;
    else
        pause(0.01);
    end
end
