function [globalTlocal] = MarkerCoord2Xform(markers, coord, origin, timeinst, rot_offset)
% This is an internal function. Should not be required to be called
% directly. 
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

if (nargin < 5)
    rot_offset = eye(4,4);
end
    
numSamples = size(markers,1);

origin_location_f = reshape(markers(floor(timeinst),origin,:),1,3);
origin_location_c = reshape(markers(floor(timeinst)+1,origin,:),1,3);

oaxis_point_f = reshape(markers(floor(timeinst),coord,:),1,3);
oaxis_point_c = reshape(markers(floor(timeinst)+1,coord,:),1,3);

xaxis_point_f = reshape(markers(floor(timeinst),coord+2,:),1,3);
xaxis_point_c = reshape(markers(floor(timeinst)+1,coord+2,:),1,3);

yaxis_point_f = reshape(markers(floor(timeinst),coord+3,:),1,3);
yaxis_point_c = reshape(markers(floor(timeinst)+1,coord+3,:),1,3);

zaxis_point_f = reshape(markers(floor(timeinst),coord+1,:),1,3);
zaxis_point_c = reshape(markers(floor(timeinst)+1,coord+1,:),1,3);

if (all(oaxis_point_f == [0,0,0]) || ...
    all(xaxis_point_f == [0,0,0]) || ...
    all(yaxis_point_f == [0,0,0]) || ...
    all(zaxis_point_f == [0,0,0]) || ...
    all(oaxis_point_c == [0,0,0]) || ...
    all(xaxis_point_c == [0,0,0]) || ...
    all(yaxis_point_c == [0,0,0]) || ...
    all(zaxis_point_c == [0,0,0]))
    oaxis_point_f = [0,0,0];
    xaxis_point_f = [1,0,0];
    yaxis_point_f = [0,1,0];
    zaxis_point_f = [0,0,1];
    oaxis_point_c = [0,0,0];
    xaxis_point_c = [1,0,0];
    yaxis_point_c = [0,1,0];
    zaxis_point_c = [0,0,1];
    warning('Bad marker data.');    
end
    
xaxis_vect_f = xaxis_point_f - oaxis_point_f;
xaxis_vect_f = xaxis_vect_f ./ norm(xaxis_vect_f);
yaxis_vect_f = yaxis_point_f - oaxis_point_f;
yaxis_vect_f = yaxis_vect_f ./ norm(yaxis_vect_f);
zaxis_vect_f = zaxis_point_f - oaxis_point_f;
zaxis_vect_f = zaxis_vect_f ./ norm(zaxis_vect_f);
xaxis_vect_c = xaxis_point_c - oaxis_point_c;
xaxis_vect_c = xaxis_vect_c ./ norm(xaxis_vect_c);
yaxis_vect_c = yaxis_point_c - oaxis_point_c;
yaxis_vect_c = yaxis_vect_c ./ norm(yaxis_vect_c);
zaxis_vect_c = zaxis_point_c - oaxis_point_c;
zaxis_vect_c = zaxis_vect_c ./ norm(zaxis_vect_c);

if (((xaxis_vect_f * yaxis_vect_f') > 0.0001) || ...
    ((xaxis_vect_f * zaxis_vect_f') > 0.0001) || ...
    ((yaxis_vect_f * zaxis_vect_f') > 0.0001) || ...
    ((xaxis_vect_c * yaxis_vect_c') > 0.0001) || ...
    ((xaxis_vect_c * zaxis_vect_c') > 0.0001) || ...
    ((yaxis_vect_c * zaxis_vect_c') > 0.0001))
    error('Bad marker data.');    
end

localROTglobal_f = [xaxis_vect_f; ...
                    yaxis_vect_f; ...
                    zaxis_vect_f];
localROTglobal_c = [xaxis_vect_c; ...
                    yaxis_vect_c; ...
                    zaxis_vect_c];

alpha = timeinst - floor(timeinst);

localROTglobal = to_matrix(slerp(quaternion(localROTglobal_f), ...
                                 quaternion(localROTglobal_c), alpha));
localROTglobal = [localROTglobal, [0; 0; 0]; ...
                  0, 0, 0, 1];

globalTRANSlocal = [eye(3,3), ...
                    (1 - alpha) * origin_location_f' + alpha * origin_location_c'; ...
                    0, 0, 0, 1];

globalTlocal = globalTRANSlocal * inv(localROTglobal) * rot_offset;