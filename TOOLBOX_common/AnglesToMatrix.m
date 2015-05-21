function [M] = AnglesToMatrix(theta, fi, tau, order)
% Converts Euler angle decomposition into rotation matrix M.
% 
% Format:
%   [ANGLES] = MatrixToAngles(PHI, THETA, PSI, ORDER)
%
% Input:
%   PHI    - angle of rotation around x-axis
%   THETA  - angle of rotation around y-axis
%   PSI    - angle of rotation around z-axis
%   ORDER  - decomposition order, with possible string values of 
%            ('XYZ', 'YXZ', 'ZXY', 'ZYX')
%
% Output:
%   ANGLES - 4-by-4 rotation matrix (in 3D).
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

Rx = [1           0          0      0 
      0  cos(theta) -sin(theta)     0
      0  sin(theta) cos(theta)      0
      0           0          0      1];
 
Ry = [cos(fi)  0   sin(fi)  0
         0     1      0     0
      -sin(fi) 0   cos(fi)  0
         0     0      0     1];

Rz = [cos(tau) -sin(tau) 0  0 
      sin(tau)  cos(tau) 0  0
      0        0         1  0
      0        0         0  1];

if (order == 'XYZ') 
    M = Rx*Ry*Rz;
elseif (order == 'ZYX')
    M = Rz*Ry*Rx;
elseif (order == 'YXZ')
    M = Ry*Rx*Rz;    
elseif (order == 'ZXY')
    M = Rz*Rx*Ry;    
elseif (1)
    fprintf('not-supported decomposition scheme');
end
