function [] = display(this)
% DISPLAY - Print out quaternion
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
  
disp(sprintf('%g %s %gi %s %gj %s %gk', ...
             this.value(1), signc(this.value(2)), abs(this.value(2)), ...
             signc(this.value(3)), abs(this.value(3)), ...
             signc(this.value(4)), abs(this.value(4))))
  

function c = signc(i)  
s = {'-', '+'};
c = s{1 + (i >= 0)};
