%% 
%  BaseClasses is from Direct X 9.0 SDK 2002
%  Mex code here based on GrabBitmaps.cpp in DirectShow samples
%

mex -IBaseClasses dxAviOpenMex.cpp BaseClasses\Debug\strmbasd.lib winmm.lib odbc32.lib odbccp32.lib quartz.lib vfw32.lib
mex -IBaseClasses dxAviReadMex.cpp BaseClasses\Debug\strmbasd.lib winmm.lib odbc32.lib odbccp32.lib quartz.lib vfw32.lib
mex -IBaseClasses dxAviCloseMex.cpp BaseClasses\Debug\strmbasd.lib winmm.lib odbc32.lib odbccp32.lib quartz.lib vfw32.lib

