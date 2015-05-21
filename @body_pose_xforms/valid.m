function [val] = valid(this);
% VALID Verify that BODY_POSE_XFORMS object is valid.
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

val = 1;

if ((size(this.torso,1)~=4) || (size(this.torso,2)~=4) || (any(isnan(this.torso(:)))) || (any(isinf(this.torso(:)))))
    val = 0;
end

if ((size(this.upperLArm,1)~=4) || (size(this.upperLArm,2)~=4) || (any(isnan(this.upperLArm(:)))) || (any(isinf(this.upperLArm(:)))))
    val = 0;
end
if ((size(this.lowerLArm,1)~=4) || (size(this.lowerLArm,2)~=4) || (any(isnan(this.lowerLArm(:)))) || (any(isinf(this.lowerLArm(:)))))
    val = 0;
end

if ((size(this.upperRArm,1)~=4) || (size(this.upperRArm,2)~=4) || (any(isnan(this.upperRArm(:)))) || (any(isinf(this.upperRArm(:)))))
    val = 0;
end
if ((size(this.lowerRArm,1)~=4) || (size(this.lowerRArm,2)~=4) || (any(isnan(this.lowerRArm(:)))) || (any(isinf(this.lowerRArm(:)))))
    val = 0;
end

if ((size(this.upperLLeg,1)~=4) || (size(this.upperLLeg,2)~=4) || (any(isnan(this.upperLLeg(:)))) || (any(isinf(this.upperLLeg(:)))))
    val = 0;
end
if ((size(this.lowerLLeg,1)~=4) || (size(this.lowerLLeg,2)~=4) || (any(isnan(this.lowerLLeg(:)))) || (any(isinf(this.lowerLLeg(:)))))
    val = 0;
end

if ((size(this.upperRLeg,1)~=4) || (size(this.upperRLeg,2)~=4) || (any(isnan(this.upperRLeg(:)))) || (any(isinf(this.upperRLeg(:)))))
    val = 0;
end
if ((size(this.lowerRLeg,1)~=4) || (size(this.lowerRLeg,2)~=4) || (any(isnan(this.lowerRLeg(:)))) || (any(isinf(this.lowerRLeg(:)))))
    val = 0;
end

if ((size(this.head,1)~=4) || (size(this.head,2)~=4) || (any(isnan(this.head(:)))) || (any(isinf(this.head(:)))))
    val = 0;
end
        