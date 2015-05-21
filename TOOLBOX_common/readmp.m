% Parser for the Vicon .mp file format. Vicon .mp files contain subject
% specific information such as the weight and height of the person, some
% limb lengths and cross-sections at the joints.
% 
% Format:
%   [PARAMS, VALS] = readmp(FILENAME);
%   [PARAMS, VALS, PARAM_VAL] = readmp(FILENAME, PARAM_NAME);
% 
% Input:
%   FILENAME   - .mp filename with full path
%   PARAM_NAME - parameter value of which to query (string)
%
% Output:
%   PARAMS     - list of parameters stored in the .mp file (strings)
%   VALS       - values of the Ccorresponding prameters 
%   PARAM_VAL  - value of the queried parameter if such supplied
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

function [parameters, values, param_val] = readmp(filename, parameter_name);

[a] = textread(filename, '%s', 'delimiter' ,'=$ ');

for I=1:size(a,1)
    if (mod((I-1),3) == 0)
        continue;
    end
    
    if (mod((I-2),3) == 0)
        parameters(floor((I-2)/3)+1, 1:size(char(a(I)),2)) = char(a(I));
    end
    
    if (mod(I,3) == 0)
        values(floor(I/3)) = str2num(char(a(I)));
    end    
end

if (nargin == 2)
    if (nargout == 3)
        param_val = ParameterValueFromSubString(parameters, values, parameter_name);
    else
        error('Must have three output parameters, when quiring for a "parameter".');        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [value] = ParameterValueFromSubString(parameters, values, str)
for I=1:size(parameters,1)
    if (~isempty(findstr(parameters(I,:), str)))
        value = values(I);
        return;
    end
end
ASSERT(0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = ASSERT(boo)
if (boo == 0)
    fprintf('Assertion FAILED.\n');
end
   