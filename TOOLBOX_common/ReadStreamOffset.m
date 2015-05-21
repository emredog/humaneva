function [im_st, mc_st, mc_sc] = ReadStreamOffset(filename);
% Reads the stream offsets/scaling from the file
%
% Format:
%   [IM_ST, MC_ST, MC_SC] = ReadSpicaCalib(FILENAME);
%
% Input:
%    FILENAME - file name of the stream offsets (e.g. StreamOffset.ofs) 
%               including full path
%
% Output: 
%   IM_ST  - starting frame index in the Spica (image) stream
%   MC_ST  - correstponding frame index in the Vicon (mocap) stream
%   MC_SC  - temporal scaling between streams 
%
% One can map an arbitrary MOCAP frame index to image frame index or vice
% versa using the following equations:
%       MocapIndex = MOCAP_ST + (ImageIndex - IM_ST) * MOCAP_SC
%       ImageIndex = IM_ST + (MocapIndex - MOCAP_ST) / MOCAP_SC
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

if (~exist(filename))    
    error(sprintf('%s file does not exist.', filename));    
end
    
fid = fopen(filename,'r');    
[im_st] = fscanf(fid, '%f', 1);
[mc_st] = fscanf(fid, '%f', 1);
[mc_sc] = fscanf(fid, '%f', 1);
fclose(fid);            

