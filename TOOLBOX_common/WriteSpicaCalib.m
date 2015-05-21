function [] = WriteSpicaCalib(calfilename, fc, cc, alpha_c, kc, Rc_ext, omc_ext, Tc_ext)
% Write the calibration into the file
%
% Format:
%   WriteSpicaCalib(CALFILENAME, FC, CC, ALPHA_C, KC, 
%                                          RC_EXT, OMC_EXT, TC_EXT)
%
% Input:
%    CALFILENAME - file name of the calibration (e.g. Spica1Calib.cal) 
%                  including full path
%    FC          - Focal length (2x1)
%    CC          - Principle point (2x1)
%    ALPHA_C     - Skew coefficient (1x1)
%    KC          - Distortion coefficient (5x1)
%    RC_EXT      - Extrinsic rotation matrix (3x3)
%    OMC_EXT     - Extrinsic rotation angles, simply a decomposition
%                  of RC_EXT (3x1)
%    TC_EXT      - Extrinsic translation vector (3x1)
%
% To map from world coordinate point X to the camera reference frame 
% point Xc, do the following: Xc = RC_EXT * X + TC_EXT;
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


cont = 1;
if (exist(calfilename))
    warning(sprintf('%s file already exists.', calfilename));    
    cont = input('Continue anyway? (1=yes, 0=no, []=no): ');
    if (isempty(cont))
        cont = 0;    
    end    
end
    
if (cont)
    fid = fopen(calfilename,'w');    
    fprintf(fid, '%f \n', fc);
    fprintf(fid, '%f \n', cc);
    fprintf(fid, '%f \n', alpha_c);
    fprintf(fid, '%f \n', kc);
    r = Rc_ext';    
    fprintf(fid, '%f \n', r(:));
    fprintf(fid, '%f \n', Tc_ext);
    fclose(fid);            
end

