function [hdl, inf] = dxAviOpen(fname);

	[hdl, t] = dxAviOpenMex(fname);
	inf.Width = t(1);
	inf.Height = t(2);
	inf.NumFrames = t(3);
	inf.fps = t(4);
	inf.total_time_sec = t(5);	
