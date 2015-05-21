function [hdl, inf] = dxAviOpen(fname)

	hdl = VideoReader(fname);
	inf.Width = hdl.Width;
	inf.Height = hdl.Height;
	inf.NumFrames = hdl.NumberOfFrames;
	inf.fps = hdl.FrameRate;
	inf.total_time_sec = hdl.Duration;	
