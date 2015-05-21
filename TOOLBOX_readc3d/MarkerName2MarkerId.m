function [marker_id] = MarkerName2MarkerId(ParameterGroup, markerName)
% [id] = MarkerName2MarkerId(ParameterGroup, markerName)
% 
% MarkerName2MarkerId - converts marker name to an id, such that
%                       corresponding marker data can be extracted.
%
% Use:
%   [Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate, ...
%          Event,ParameterGroup,CameraInfo,ResidualError]=readc3d(FullFileName);
%   [pelo_id] = MarkerName2MarkerId(ParameterGroup, 'PELO');
%
% Written By:   Leonid Sigal (ls@cs.brown.edu)
% Last Updated: 2/1/04

if (size(markerName,1) ~= 1)
    error('markerName must be a string.');    
end

marker_id = [];
n_markers = 0;

group_id = -1;
sub_group_id = -1;

for I = 1:size(ParameterGroup,2)
    if (~isempty(findstr(char(ParameterGroup(I).name), 'POINT')))
        group_id = I;
    end
end
if (group_id == -1)
    error('POINT group is not present in the .c3d file');    
end

for I = 1:size(ParameterGroup(group_id).Parameter,2)
    if (~isempty(findstr(char(ParameterGroup(group_id).Parameter(I).name), 'LABELS')))
        sub_group_id = I;
    end
end
if (sub_group_id == -1)
    error('LABELS sub-group is not present in the .c3d file');    
end

for I = 1:size(ParameterGroup(group_id).Parameter(sub_group_id).data,2)
    if (~isempty(findstr(char(ParameterGroup(group_id).Parameter(sub_group_id).data(I)), markerName)))
        n_markers = n_markers + 1;
        marker_id(n_markers) = I;
    end
end
