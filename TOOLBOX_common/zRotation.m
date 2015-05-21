function [xform] = zRotation(psi, hand)
% Generates 3-D rotation matrix for the z-axis rotation
% 
% Format: 
%   [XFORM] = zRotation(PSI, HAND)
%
% Input:
%   PSI   - angle of rotation around z-axis
%   HAND  - handidness of the coordinate system
%             1 = right handed
%            -1 = left handed
% Output:
%   XFORM - 3-D rotation matrix
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

if (nargin < 1)
    error('Function requires at least one parameter')
end
if (nargin < 2)
    hand = 1;    
else
    if ((hand ~= 1) && (hand ~= -1))
        error('Supply -1 for Left Handed Coordinate System, 1 for the Right Handed Coordinate System');
    end
end

xform = [ cos(psi)       hand*sin(psi)  0  0
         -hand*sin(psi)  cos(psi)       0  0
          0              0              1  0
          0              0              0  1];
 
      