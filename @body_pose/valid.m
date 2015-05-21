function [val] = valid(this);
% VALID Verify that BODY_POSE object is valid.
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

val(1) = or(length(this.torsoProximal) == 3, length(this.torsoProximal) == 2);
val(2) = (length(this.torsoProximal) == length(this.torsoDistal));
val(3) = (length(this.torsoProximal) == length(this.upperLArmProximal));
val(4) = (length(this.torsoProximal) == length(this.upperLArmDistal));
val(5) = (length(this.torsoProximal) == length(this.lowerLArmProximal));
val(6) = (length(this.torsoProximal) == length(this.lowerLArmDistal));
val(7) = (length(this.torsoProximal) == length(this.upperRArmProximal));
val(8) = (length(this.torsoProximal) == length(this.upperRArmDistal));
val(9) = (length(this.torsoProximal) == length(this.lowerRArmProximal));
val(10) = (length(this.torsoProximal) == length(this.lowerRArmDistal));
val(11) = (length(this.torsoProximal) == length(this.upperLLegProximal));
val(12) = (length(this.torsoProximal) == length(this.upperLLegDistal));
val(13) = (length(this.torsoProximal) == length(this.lowerLLegProximal));
val(14) = (length(this.torsoProximal) == length(this.lowerLLegDistal));
val(15) = (length(this.torsoProximal) == length(this.upperRLegProximal));
val(16) = (length(this.torsoProximal) == length(this.upperRLegDistal));
val(17) = (length(this.torsoProximal) == length(this.lowerRLegProximal));
val(18) = (length(this.torsoProximal) == length(this.lowerRLegDistal));
val(19) = (length(this.torsoProximal) == length(this.headProximal));
val(20) = (length(this.torsoProximal) == length(this.headDistal));

val = logical(prod(double(val)));