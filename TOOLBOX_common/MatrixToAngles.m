function [angles] = MatrixToAngles(M, order)
% Decomposes rotation matrix M into Euler angles of a given order.
% 
% Format:
%   [ANGLES] = MatrixToAngles(M, ORDER)
%
% Input:
%   M      - 4-by-4 rotation matrix (in 3D)
%   ORDER  - decomposition order, with possible string values of 
%            ('XYZ', 'YXZ', 'ZXY', 'ZYX')
%
% Output:
%   ANGLES - 3-by-1 vector of angles arranged in the XYZ order.
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

thetaX = 0;
thetaY = 0;
thetaZ = 0;

if (order == 'XYZ')
     thetaY = asin(M(1,3));
     if (thetaY < (pi/2))
        if (thetaY > (-pi/2))
           thetaX = atan2(-M(2,3), M(3,3));
           thetaZ = atan2(-M(1,2), M(1,1));
        else
           warning('Not unique solution.');
           thetaX = -atan2(M(2,1), M(2,2));
           thetaZ = 0;
        end
     else 
        warning('Not unique solution.');
        thetaX = atan2(M(2,1), M(2,2));
        thetaZ = 0;
     end
elseif (order == 'YXZ')
     thetaX = asin(-M(2,3));
     if (thetaX < (pi/2))
        if (thetaX > (-pi/2))
           thetaY = atan2(M(1,3), M(3,3));
           thetaZ = atan2(M(2,1), M(2,2));
        else
          warning('Not unique solution.');
          thetaY = -atan2(-M(1,2), M(1,1));
          thetaZ = 0;
        end
     else
        warning('Not unique solution.');
        thetaY = atan2(-M(1,2), M(1,1));
        thetaZ = 0;
     end
elseif (order == 'ZXY')
     thetaX = asin(M(3,2));
     if (thetaX < (pi/2))
        if (thetaX > (-pi/2))
           thetaZ = atan2(-M(1,2), M(2,2));
           thetaY = atan2(-M(3,1), M(3,3));
        else
           warning('Not unique solution.');
           thetaZ = -atan2(M(1,3), M(1,1));
           thetaY = 0;
        end
     else
        warning('Not unique solution.');
        thetaZ = atan2(M(1,3), M(1,1));
        thetaY = 0;
     end
elseif (order == 'ZYX')
     thetaY = asin(-M(3,1));
     if (thetaY < (pi/2))
        if (thetaY > (-pi/2))
           thetaZ = atan2(M(2,1), M(1,1));
           thetaX = atan2(M(3,2), M(3,3));
        else
           warning('Not unique solution.');
           thetaZ = -atan2(-M(1,2), M(1,3));
           thetaX = 0;        
        end
     else
        warning('Not unique solution.');
        thetaZ = atan2(-M(1,2), M(1,3));
        thetaX = 0;        
     end
elseif (1)
     warning('Not-supported decomposition scheme.');
end

angles = [thetaX, thetaY, thetaZ];


