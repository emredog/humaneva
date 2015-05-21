function this = from_matrix(this, m)
% FROM_MATRIX - Convert 3x3 rotation matrix into unit quaternion
%
% This is a MATLAB translation of the algorithm in VXL.  See
% http://vxl.sf.net for license terms.
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
  
d0 = m(1, 1); d1 = m(2, 2); d2 = m(3, 3);
xx = 1.0 + d0 - d1 - d2;               % from the diagonal of rotation
yy = 1.0 - d0 + d1 - d2;               % matrix, find the terms in
zz = 1.0 - d0 - d1 + d2;               % each Quaternion compoment
rr = 1.0 + d0 + d1 + d2;

[best, idx] = max([xx yy zz rr]);      % find the maximum of all
                                       % diagonal terms.
switch(idx)
    case 4
        a = 0.5 * sqrt(rr); 
        a4 = 4 * a;
        this.value = [a; ...
                      (m(3, 2) - m(2, 3)) / a4; ...
                      (m(1, 3) - m(3, 1)) / a4;
                      (m(2, 1) - m(1, 2)) / a4];
    case 1
        a = 0.5 * sqrt(xx); 
        a4 = 4 * a;
        this.value = [(m(3, 2) - m(2, 3) ) / a4; ...
                      a; ...
                      (m(1, 2) + m(2, 1) ) / a4; ...
                      (m(1, 3) + m(3, 1) ) / a4]; 
    case 2
        a = 0.5 * sqrt(yy); 
        a4 = 4 * a;
        this.value = [(m(1, 3) - m(3, 1) ) / a4; ...
                      (m(1, 2) + m(2, 1) ) / a4; ...
                      a; ...
                      (m(2, 3) + m(3, 2) ) / a4]; 
    case 3
        a = 0.5 * sqrt(zz); 
        a4 = 4 * a;
        this.value = [(m(2, 1) - m(1, 2) ) / a4; ...
                      (m(1, 3) + m(3, 1) ) / a4; ...
                      (m(2, 3) + m(3, 2) ) / a4; ...
                      a];
  end

  if (abs(1 - norm(this)) > 1E-5)
        keyboard
  end