function this = quaternion(varargin) 
% QUATERNION - Class representing quaternions
%
% Syntax:
%  
%       object = QUATERNION(a, b, c, d)
%       object = QUATERNION(rot)
%       object = QUATERNION(axis, phi)
%       object = QUATERNION(other)
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
  
error(nargchk(1, 4, length(varargin)));
  
switch (length(varargin))
    case 1
        if isa(varargin{1}, 'quaternion')
            this = varargin{1};
        else
            if (prod(size(varargin{1})) > length(varargin{1}))
                this.value = [0; 0; 0; 0];
                this = class(this, 'quaternion');
        
                this = from_matrix(this, varargin{1});
            else
                v = varargin{1}(:);
        
                if (length(v) == 1)
                    this.value = [v; 0; 0; 0];
                else
                    this.value = v(1:4);
                end
                this = class(this, 'quaternion');      
            end
        end

    case 2
        n = varargin{1}(:);
        n = n ./ norm(n);
    
        this.value = [cos(0.5 * varargin{2}); sin(0.5 * varargin{2}) * n];
        this = class(this, 'quaternion');

    case 4
        this.value = [varargin{1}; varargin{2}; varargin{3}; varargin{4}];
        this = class(this, 'quaternion');

end 