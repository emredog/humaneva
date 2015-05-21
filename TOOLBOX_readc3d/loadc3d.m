% script loadc3d

[datafile,datapath] = uigetfile('*.c3d', 'open C3D file', 'MultiSelect', 'on');

if ~isempty(datafile)
    for I = 1:length(datafile)
        [Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate,Event,ParameterGroup,CameraInfo,ResidualError]=...
              readC3d([datapath,datafile{I}]);

        mat_filename = [datapath datafile{I}];
        mat_filename(end-2:end) = 'mat';
        save(mat_filename, 'Markers', 'VideoFrameRate', 'AnalogSignals', ... 
                           'AnalogFrameRate', 'Event', 'ParameterGroup', ...
                           'CameraInfo', 'ResidualError', '-MAT', '-V6');
    end
end
  
