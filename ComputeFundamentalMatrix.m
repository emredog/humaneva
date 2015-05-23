function [ F_12, F_21 ] = ComputeFundamentalMatrix( calFile1, calFile2 )
%COMPUTEFUNDAMENTALMATRIX Given calibration parameters of two cameras,
%calculates both fundamental matrices.
%
% TODO: This version does not takes radial & tangential distortion
% coefficients (kc) and skew coefficient (alpha_c).
%
% INPUT:
%   calFile1: Calibration File of camera 1
%   calFile2: Calibration File of camera 2
%
%OUTPUT:
%   F_12: matrix that takes a point from camera 1 and transforms to a
%         epipolar line in camera 2,  e.g. e_line_2 = F_12*p_1
%   F_21: matrix that takes a point from camera 2 and transforms to a
%         epipolar line in camera 1,  e.g. e_line_1 = F_21*p_2

% read calibration data from file:
[fc, cc, alpha_c, kc, Rc_ext, omc_ext, Tc_ext] = ReadSpicaCalib(calFile1);

Tw2c = [Rc_ext, Tc_ext]; % extrinsic matrix

Tc2i = [fc(1), 0,     cc(1); %intrinsic matrix
        0    , fc(2), cc(2);
        0    , 0    , 1   ];

P1 = Tc2i * Tw2c; % projection matrix for camera 1 (to world coordinates)

% read calibration data from file:
[fc, cc, alpha_c, kc, Rc_ext, omc_ext, Tc_ext] = ReadSpicaCalib(calFile2);

Tw2c = [Rc_ext, Tc_ext]; % extrinsic matrix

Tc2i = [fc(1), 0,     cc(1); %intrinsic matrix
        0    , fc(2), cc(2);
        0    , 0    , 1   ];

P2 = Tc2i * Tw2c; % projection matrix for camera 1 (to world coordinates)

% compute fundamental matrix F_12
M_1 = P1(:,1:3);
C_1 = -inv(M_1) * P1(:,4);
e_2 = P2*[C_1;1]; 
E_2 = [ 0,      -e_2(3), e_2(2);
        e_2(3),  0,     -e_2(1);
       -e_2(2),  e_2(1), 0    ];

F_12 = E_2 * P2 * pinv(P1);

% compute fundamental matrix F_21
M_2 = P2(:,1:3);
C_2 = -inv(M_2) * P2(:,4);
e_1 = P1*[C_2;1]; 
E_1 = [ 0,      -e_1(3), e_1(2);
        e_1(3),  0,     -e_1(1);
       -e_1(2),  e_1(1), 0    ];
   
F_21 = E_1 * P1 * pinv(P2);

end

