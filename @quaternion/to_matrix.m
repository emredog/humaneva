function m = to_matrix(this)
% TO_MATRIX - Convert unit quaternion into 3x3 rotation matrix
%
% Implementation of the algorithm described at
% http://www.euclideanspace.com/maths/algebra/matrix/orthogonal/rotation/
%
% Author:  Stefan Roth <roth@cs.brown.edu>
% Date:    03/27/2004
% Version: 0.1
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
 
this.value = this.value ./ norm(this);
  
w = this.value(1);
x = this.value(2);
y = this.value(3);
z = this.value(4);
  
m = eye(3, 3) + 2 * [-y^2 - z^2, x*y - w*z, x*z + w*y; ...
                      x*y + w*z, -x^2 - z^2, y*z - w*x; ...
                      x*z - w*y, y*z + w*x, -x^2 - y^2];
