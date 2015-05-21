function [res] = query(this, varargin)
% QUERY Query the set of HE_DATASET objects.
%
% Syntax:
%       [objects] = QUERY(this);
%       [objects] = QUERY(this, field, value);
%       [objects] = QUERY(this, field1, value1, field2, value2);
%       [objects] = QUERY(this, field1, value1, field2, value2, ...);
%
%   THIS   - 1xN or Nx1 array of DATASET objects
%   FIELD  - string designating the field name of the HEDATASET object that
%            one wants to limit
%   VALUE  - requirement on the value of the field (above) 
%   OBJECT - 1xM or Mx1 array of HE_DATASET objects, where M <= N. This is
%            a sub-set of THIS that adhere to the restrictions given by the 
%            FIELD and VALUE pairs.
%
% Written by: Leonid Sigal 
% Revision:   1.1
% Date:       8/11/2007
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

if (floor((nargin-1)/2.0) ~= ceil((nargin-1)/2.0))
    error('Bad number of arguments');
end

res = this;

for I = 1:floor((nargin-1)/2.0)
    field = varargin{I*2-1};
    value = varargin{I*2};
    
    if (~strcmp(field, 'Frame'))      
        InconsistentEntries = []; 
        for J = 1:length(res)
            eval(['field_content = res(J).' field ';']);
            if (isstr(field_content))
                if (~strcmp(field_content, value))
                    InconsistentEntries(end+1) = J;
                end                  
            elseif (isnum(field_content))
                if (field_content ~= value)
                    InconsistentEntries(end+1) = J;
                end        
            end
        end
        res(InconsistentEntries) = [];
    else
        InconsistentEntries = []; 
        for J = 1:length(res)
            if (~and(value >= res(J).FrameStart, value <= res(J).FrameEnd))
                InconsistentEntries(end+1) = J;                
            end
        end
        res(InconsistentEntries) = [];
    end    
end