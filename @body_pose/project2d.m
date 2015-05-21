function [pose2d] = project2d(this, calibfilename)
% PROJECT2D converts the 3D pose to a 2D subject to the calibration.
%
% Syntax: 
%       [pose2d] = BODY_POSE(this, calibfilename) - Where "calibfilename"
%                      is full path to the calibration file.
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

[fc, cc, alpha_c, kc, Rc_ext, omc_ext, Tc_ext] = ReadSpicaCalib(calibfilename);
    
pose2d = this;

for I = 1:length(this)   
    joints3d = [    this(I).torsoProximal(:)    , ...
                    this(I).torsoDistal(:)      , ...
                    this(I).upperLArmProximal(:), ...
                    this(I).upperLArmDistal(:)  , ...
                    this(I).lowerLArmProximal(:), ...
                    this(I).lowerLArmDistal(:)  , ...
                    this(I).upperRArmProximal(:), ...
                    this(I).upperRArmDistal(:)  , ...
                    this(I).lowerRArmProximal(:), ...
                    this(I).lowerRArmDistal(:)  , ...
                    this(I).upperLLegProximal(:), ...
                    this(I).upperLLegDistal(:)  , ...
                    this(I).lowerLLegProximal(:), ...
                    this(I).lowerLLegDistal(:)  , ...
                    this(I).upperRLegProximal(:), ...
                    this(I).upperRLegDistal(:)  , ...
                    this(I).lowerRLegProximal(:), ...
                    this(I).lowerRLegDistal(:)  , ...
                    this(I).headProximal(:)     , ... 
                    this(I).headDistal(:)               ];
    
    [joints2d,dxpdom,dxpdT,dxpdf,dxpdc,dxpdk,dxpdalpha] = ...
               project_points2(joints3d,omc_ext,Tc_ext,fc,cc,kc,alpha_c); 
         
    pose2d(I).torsoProximal     = joints2d(:, 1);
    pose2d(I).torsoDistal       = joints2d(:, 2);
    pose2d(I).upperLArmProximal = joints2d(:, 3);
    pose2d(I).upperLArmDistal   = joints2d(:, 4);
    pose2d(I).lowerLArmProximal = joints2d(:, 5);
    pose2d(I).lowerLArmDistal   = joints2d(:, 6);
    pose2d(I).upperRArmProximal = joints2d(:, 7);
    pose2d(I).upperRArmDistal   = joints2d(:, 8);
    pose2d(I).lowerRArmProximal = joints2d(:, 9);
    pose2d(I).lowerRArmDistal   = joints2d(:,10);
    pose2d(I).upperLLegProximal = joints2d(:,11);
    pose2d(I).upperLLegDistal   = joints2d(:,12);
    pose2d(I).lowerLLegProximal = joints2d(:,13);
    pose2d(I).lowerLLegDistal   = joints2d(:,14);
    pose2d(I).upperRLegProximal = joints2d(:,15);
    pose2d(I).upperRLegDistal   = joints2d(:,16);
    pose2d(I).lowerRLegProximal = joints2d(:,17);
    pose2d(I).lowerRLegDistal   = joints2d(:,18);
    pose2d(I).headProximal      = joints2d(:,19);    
    pose2d(I).headDistal        = joints2d(:,20);
end