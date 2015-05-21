function this = mtimes(this, other)
% MTIMES - Multiply two quaternions
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
  
if (isa(this, 'double'))
    other.value = other.value * this;
    this = other;
elseif (isa(other, 'double'))
    this.value = this.value * other;
else
    a = this.value; 
    b = other.value;
    
    tmp = [a(1)*b(1) - a(2)*b(2) - a(3)*b(3) - a(4)*b(4); ...
           a(1)*b(2) + a(2)*b(1) + a(3)*b(4) - a(4)*b(3); ...
           a(1)*b(3) - a(2)*b(4) + a(3)*b(1) + a(4)*b(2); ...
           a(1)*b(4) + a(2)*b(3) - a(3)*b(2) + a(4)*b(1)];
    this.value = tmp;
end