function [this, fname, img, map] = prev_image(this); 
% PREV_IMAGE Accesor function allows referencing stream object IMAGE_STREAM.
% 
% [...] = PREV_IMAGE(...) reads the previous grayscale or color image from 
% the image stream specified by the IMAGE_STREAM object. See the reference 
% page, or the output of the constructor IMAGE_STREAM, for a list of 
% supported options.  
%
% Syntax:
%   [THIS, FNAME] = prev_image(THIS);
%   [THIS, FNAME, IMG] = prev_image(THIS);
%   [THIS, FNAME, IMG, MAP] = prev_image(THIS);
%
% Input:
%   THIS        - IMAGE_STREAM object.
%
% Output: 
%   THIS        - IMAGE_STREAM object (updated) 
%   FNAME       - Filename corresponding to the current image (for the 
%                 sequenced BMPs) or AVI file for the video.
%   IMG         - Image data in the array format. If the file contains a
%                 grayscale images, IMG is a two-dimensional (M-by-N) 
%                 array.  If the file contains a color image, IMG is a 
%                 three-dimensional (M-by-N-by-3) array.  The class of the 
%                 returned array depends on the data type used by the file 
%                 format.
%   MAP         - Associated colormap of the IMG. Colormap values in the
%                 image file are automatically rescaled into the 
%                 range [0,1]. 
%
% Notes: 
%   If IMG is not specified the resulting current image will be displayed.
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

this.current_position = this.current_position - 1;

if (strcmp(this.mode, 'sequenced images'))
    bn_start   = this.start_filename.bn;
    lz_start   = this.start_filename.lz;
    fcnt_start = this.start_filename.fcnt;
    ext_start  = this.start_filename.ext;
    
    fcnt_current = fcnt_start + this.stream_offset + (this.current_position - 2) * this.stream_scaling;
    
    lz_current   = lz_start + (length(int2str(fcnt_start)) - length(int2str(fcnt_current)));
    lz_str = '';
    for J = 1:lz_current
        lz_str = [lz_str '0'];
    end

    filename = sprintf('%s%s%d.%s', bn_start, lz_str, round(fcnt_current), ext_start);
    
    if ((nargout == 1) || (nargout == 0))
        imshow(filename);
    end

    if (nargout >= 2)
        fname = filename;
    end

    if (nargout == 3)
        img = double(imread(filename)) ./ 255;
    end
    
    if (nargout == 4)
        [img, map] = imread(filename);
        img = double(img) ./ 255;
    end
end

if (strcmp(this.mode, 'video'))
    frame_index = this.stream_offset + (this.current_position - 1) * this.stream_scaling;
    
    try 
        mov = aviread(this.start_filename, frame_index);
    catch
        pixmap = dxAviReadMex(this.avi_hdl, frame_index);
	    mov.cdata = reshape(pixmap/255,[this.avi_info.Height,this.avi_info.Width,3]);  
        mov.map = [];

        % [avi_hdl, avi_inf] = dxAviOpen(this.start_filename);	
    	% pixmap = dxAviReadMex(avi_hdl, frame_index);
	    % mov.cdata = reshape(pixmap/255,[avi_inf.Height,avi_inf.Width,3]);  
        % mov.map = [];
        % dxAviCloseMex(avi_hdl);
    end
    
    if ((nargout == 1) || (nargout == 0))
        imshow(mov.cdata);
    end

    if (nargout >= 2)
        fname = this.start_filename;
    end

    if (nargout == 3)
        img = mov.cdata;
    end
    
    if (nargout == 4)
        img = mov.cdata;
        map = mov.map;
    end    
end