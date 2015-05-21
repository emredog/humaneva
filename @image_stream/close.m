function [st] = close(this) 
% CLOSE Close IMAGE_STREAM file.
% 
% [...] = CLOSE(...) closes the supplied sterm object. CLOSE returns 0 if 
% successful and -1 if not. After this function is called on the
% IMAGE_STREAM object, the object is invalidated.
%
% Syntax:
%   [OK] = close(THIS);
%
% Input:
%   THIS - 1xN or Nx1 array of IMAGE_STREAM objects.
%
% Output: 
%   OK   - 1xN or Nx1 array of logicals designating if the operation was
%          successful. 
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

st = 0;

% if (length(this) > 1)
%     for I = 1:length(this)
%         if (this(I).avi_hdl)
%             try
%                 dxAviCloseMex(this(I).avi_hdl);
%                 st(I) = 0;
%             catch
%                 st(I) = -1;
%             end
%         end
%     end
% else
%     if (this.avi_hdl)
%         try
%             dxAviCloseMex(this.avi_hdl);
%             st = 0;
%         catch
%             st = -1;
%         end            
%     end
% end


