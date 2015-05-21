function this = mpower(this, other)
% MPOWER - Raise quaternion to some power
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
  
n = norm(this);
tmp = this.value ./ n;
  
theta = acos(tmp(1));
stheta = sin(theta);

if abs(stheta)>0.000001
    % this works if sin(theta) is large 
    u = tmp(2:4) / stheta;
    this.value = (n ^ other) * [cos(other * theta); sin(other * theta) * u];
else
    % this works if sin(theta) is small
    u = other * tmp(2:4);
    this.value = (n ^ other) * [cos(other * theta); u];
end