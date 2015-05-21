[filename, pathname] = uigetfile({'*.avi','AVI file'; '*.*','Any file'},'Pick an AVI file');

%Open an handle to the AVI file
[avi_hdl, avi_inf] = dxAviOpen([pathname, filename]);

% for frame_num = 1:avi_inf.NumFrames/10:avi_inf.NumFrames;
for frame_num = avi_inf.NumFrames;
	
	%Reads frame_num from the AVI
	pixmap = dxAviReadMex(avi_hdl, frame_num-1);
	imshow(reshape(pixmap/255,[avi_inf.Height,avi_inf.Width,3]));
	title(sprintf('frame number %d',floor(frame_num)));
	fprintf('Press any key\n');
	pause;
end

%Cleanup
dxAviCloseMex(avi_hdl);
