PLEASE CONTACT ME IF YOU THINK I VIOLATE A LICENCE OR SOMEONE'S RIGHTS. 

Code obtained from: http://humaneva.is.tue.mpg.de/datasets_human_1

Initial commit is "as is". 

Xvid files can't be opened with 64bit linux Matlab. Toolbox_dxAvi is for windows, pre-compiled mex files for 32bit linux can be found online.

This is an attempt to make the default code work with Matlab R2014b's "VideoReader" object.


Original readme file below.

++++++++++++++++++

+---------------------------------------------------------------+
|          HumanEva-I Dataset and Support Code Read-Me          |
|                        (v. 1.1 beta)                          |
|           Written by Leonid Sigal (ls@cs.brown.edu)           |
+---------------------------------------------------------------+

System requirements
-------------------
- XVID codec v. 1.1.0
- Matlab v. 7.0 or later 
  
(Matlab v. 6.5 can be used if you don’t use supplied GUI code).
 

Installing XVID codec
---------------------
Support code requires XVID codec to be installed on your system. It is also required to visualize video data in Windows Media Player, or most other players. We have tested XVID codec release 1.1 however later versions are likely to work if they are backwards compatible. For installation instructions and to download codec we refer readers to:

     http://www.xvid.org/downloads.html

Once the codec is installed you should be able to play any of the video AVI files under <Subject>/Image_Data/ using standard Windows Media Player.


Installing DXAVI Toolbox 
------------------------
An integral part of the support code is the DxAVI Matlab library written by Ashwin Thangali (Boston University). The library allows reading of the ‘XVID’ videos in Matlab. It has been tested under Matlab v.6.5, v.7.0, v.7.1, and v.7.2 under windows. No testing has been done under Linux, or earlier versions of Matlab. 

Please ensure that path to the toolbox is in your Matlab path. For problems or to see how to modify the code to run under Linux, see documentation at

     http://cs-people.bu.edu/tvashwin/dx_avi/

Before attempting to use the code please make sure that DxAVI is properly installed by calling testDxAvi which will prompt for a file to load. Navigate to one of the HumanEva video files and load one of them. The image data should be displayed, if not then DxAVI is not installed properly and the rest of the support code will not work. 


Camera Calibration Toolbox for Matlab
-------------------------------------
We use camera calibration toolbox for Matlab written and maintained by Jean-Yves Bouguet for extrinsic and intrinsic calibration, as well as to project 3D points into the calibrated camera view. Full description of the toolbox and calibration parameters can be found on the official toolbox cite:

     http://www.vision.caltech.edu/bouguetj/calib_doc/

For convenience toolbox is included in this distribution in its entirety, under TOOLBOX_calib sub-directory. 


Adding toolboxes to your path
-----------------------------
All toolboxes should be added to your Matlab path as follows:

       addpath(‘./TOOLBOX_ dxAvi’);
       addpath(‘./TOOLBOX _calib’);
       addpath(‘./TOOLBOX_readc3d’);
       addpath(‘./TOOLBOX_common’);


Selecting a dataset
-------------------
This support code can be used with both HumanEva-I and HumanEva-II datasets. To run the support code for a given dataset, first copy ALL files from the corresponding subdirectory (either HumanEva_I or HumanEva_II) to the root directory. DO NOT run the code directly from subdirectories; it simply will not work.  


Running support code
--------------------
Most support code is either visual (has GUI interface) or has printouts designating the flow of the script. In general, printouts that start with “--->” will correspond to places where users are expected to modify or insert custom code. 

To familiarize yourself with the dataset first run:

     HumanEva; 

This will produce a GUI menu which will allow you to load either the full dataset or one of the valid sub-sets (e.g. Training, Validation, Testing) of the HumanEvaI. This function is simply an interface to the HumanEva_Dataset_Viewer, which can be run by itself to produce similar results:

     HumanEva_Dataset_Viewer;

To see how you can use the dataset for articulated pose estimation and tracking and subsequent evaluation of error, see 

     ComputeError2DExample;
     ComputeError3DExample;

Both functions take no parameters and show how the data can be easily loaded and used for multi-view (3D) and single view (2D) pose estimation and tracking. In 3D the error will be computed in (mm) and in 2D for convenience in (pix).


Questions and problems
----------------------
The support code is still in its infantile stages, so it is possible that there bugs in the code. If you find a bug, have a concern or need additional functionality, please contact Leonid Sigal ls@cs.brown.edu. Also, we will gratefully accept code contributions that make it either easier to use the dataset or illustrate your algorithms performance on the dataset. These extensions will be properly credited and distributed to the participants. 


Known problems
--------------
When running the support code you may get “Could not connect source filter to grabber” or “Could not run” errors from time to time. This is an issue with DXAVI toolbox. Sometimes closing a video stream produces a crash that results in the errors of this type. This issue has been observed to be more frequent with earlier versions of Matlab. Unfortunately the only known solution to this problem at the moment is to restart Matlab.

Motion capture data has been minimally post processed, as a result some frames within some video sequences will have incomplete or wrong pose data. Cases where such pose errors are caused by the undetected markers on the body can easily be detected and ignored (see valid(...) function within @body_pose class). Other cases, where the pose errors are caused by markers found in inappropriate places are more subtle and often cannot be detected automatically. We will make every effort do document inconsistent frames and exclude them from error evaluations. 

Change log 
----------

Version 0.6 beta
-	Sample background subtraction code is added 
-	XML result file export/import functionality added for the use with on-line evaluation
-	Minor miscellaneous bug fixes

Version 0.7 beta
-	Added more extensive testing/filtering for a validity of the mocap frame data.  New functionality returns a valid flag on the call to the cur_frame() function of the @mocap_stream object.

Version 0.8 beta
-	ShowPlacementOfMarkers.m is added to illustrate the placement of proximal and distal markers used for error computations.
-	Fixed the problem with the head proximal and distal markers that were reversed in the previous versions.
-	Fixed 1 frame offset error with the sequenced BMP interface of @image_strream.
-	Due to XVID codec bug that duplicates initial/first frame a number of times, first 5 video frames should not be used. To this end @dataset object has been changed to ensure that all synchronized mocap and video data streams start at frame 6.

Version 0.9 beta
-	Fixed some problems with class definition of @mocap_stream class.
-	Added support for relative error computation error_rel() function in @body_pose class.
-	Added support for HumanEva-II data.


Version 1.1 beta
-       Fixed problem with the head markers for error computations
-       Renamed `dataset' class to `he_dataset' to ensure that code works properly in Matlab 7.4 and later


-------
Copyright 2007, Brown University 
All Rights Reserved Permission to use, copy, modify, and distribute this software and its documentation for any non-commercial purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation, and that the name of the author not be used in advertising or publicity pertaining to distribution of the software without specific, written prior permission. THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. 


