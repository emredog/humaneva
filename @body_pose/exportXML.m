function [ok] = exportXML(poses, frames, cam, dset, filename, true_poses)
% exportXML Imports XML file with results.
%
% Syntax: 
%       [ok] = exportXML(poses, frames, cam, dset, filename);
%       [ok] = exportXML(poses, frames, cam, dset, filename, true_poses)
%
%   Where,
%       POSES      - 1xN or Nx1 array of BODY_POSE objects
%       FRAMES     - 1xN or Nx1 array of integer frame numbers 
%                    corresponding to the POSES
%       CAM        - camera name. Valid values are 'BW1', 'BW2', 'BW3',
%                    'BW4', 'C1', 'C2', 'C3', 'C4', ''. This is only useful
%                    for 2D, in 3D case just set CAM = ''.
%       DSET       - HE_DATASET object, designating the sequence from which 
%                    the data was taken 
%       TRUE_POSES - 1xN or Nx1 array of BODY_POSE objects corresponding 
%                    fo ground truth poses for the frames (optional). 
%
% Written by: Leonid Sigal 
% Revision:   1.1
% Date:       8/11/2007
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

DEFAUL_EMPTY_STRING = 'N/A';

if (nargin < 5)
    error('At least 5 arguments are required for the function.');
end

if (~isa(dset, 'he_dataset'))
    error('DSET should be an object of ''he_dataset'' class.');
end
if ((length(dset) > 1) || (length(dset) < 1))
    error('DSET should be a single object of ''dataset'' class.');
end

if (~(strcmp(cam, '') || strcmp(cam, 'C1') || strcmp(cam, 'C2') || ...
     strcmp(cam, 'C3') || strcmp(cam, 'C4') || strcmp(cam, 'BW1') || ...
     strcmp(cam, 'BW2') || strcmp(cam, 'BW3') || strcmp(cam, 'BW4') || ...
     strcmp(cam, 'N/A')))
    error('CAM is not valid.');
end
if strcmp(cam, '')
    cam = DEFAUL_EMPTY_STRING;
end

if (length(poses) ~= length(frames))
    error('POSES and FRAMES must be arrays of equal length.');
end
    

if (length(filename) < 1)
    error('FILENAME should be a valid absolute file path with XML extension.');
end
if (filename(end-3)  == '.')
    if (strcmp(filename(end-2:end), 'xml') || strcmp(filename(end-2:end), 'XML'))
        % do nothing 
    else
        error('FILENAME should be a valid absolute file path with XML extension.');
    end
else
    filename = [filename, '.xml'];
end

if (nargin > 5)
    if (~isa(true_poses, 'body_pose'))
        error('TRUE_POSES must be array of ''body_pose'' objects.');
    end    
    if (length(poses) ~= length(true_poses))
        error('POSES and TRUE_POSES must be arrays of equal length.');
    end
end

% Create the root node
xmlNode = com.mathworks.xml.XMLUtils.createDocument('SEQUENCE');
xmlRootNode = xmlNode.getDocumentElement;

% Create attributes of the root node, take the attribute names
% and values directly from the supplied 'dataset' object.
struct_dset = struct(dset);
struct_dset_field_names = fieldnames(struct_dset);

for I=1:length(struct_dset_field_names)
    field_name = struct_dset_field_names{I};
    field_val  = getfield(struct_dset, field_name);
    
    if (isnumeric(field_val))
        field_val = num2str(field_val);
    end
    
    xmlRootNode.setAttribute(field_name, field_val);
end

camElement = xmlNode.createElement('Camera'); 
camElement.appendChild(xmlNode.createTextNode(cam)); 
xmlRootNode.appendChild(camElement);

% Create one node for every frame considered
for I=1:length(poses)
    frameElement = xmlNode.createElement('Frame'); 
    
    frameNumberElement = xmlNode.createElement('Number'); 
    frameNumberElement.appendChild(xmlNode.createTextNode(sprintf('%d', frames(I)))); 
    frameElement.appendChild(frameNumberElement);
    
    poseElement  = xmlNode.createElement('Pose');
    fieldname    = fieldnames(poses(I));
    for J=1:length(fieldname)
        if (isempty(strfind(fieldname{J}, 'Enabled')))
            jointElement = xmlNode.createElement('Joint');
            
            jointNameElement      = xmlNode.createElement('Name');
            jointNameElement.appendChild(xmlNode.createTextNode(fieldname{J}));
            jointElement.appendChild(jointNameElement);
            
            jointEnabledElement   = xmlNode.createElement('Enabled');
            jointEnabledElement.appendChild(xmlNode.createTextNode(sprintf('%d', get(poses(I), [fieldname{J}, 'Enabled']))));   
            jointElement.appendChild(jointEnabledElement);
                
            position = get(poses(I), fieldname{J});
            if (length(position) == 3)
                jointPositionXElement = xmlNode.createElement('X');
                jointPositionXElement.appendChild(xmlNode.createTextNode(sprintf('%f', position(1))));
                jointPositionYElement = xmlNode.createElement('Y');
                jointPositionYElement.appendChild(xmlNode.createTextNode(sprintf('%f', position(2))));
                jointPositionZElement = xmlNode.createElement('Z');
                jointPositionZElement.appendChild(xmlNode.createTextNode(sprintf('%f', position(3))));
                
                jointElement.appendChild(jointPositionXElement);
                jointElement.appendChild(jointPositionYElement);
                jointElement.appendChild(jointPositionZElement);        
            elseif (length(position) == 2)
                jointPositionXElement = xmlNode.createElement('X');
                jointPositionXElement.appendChild(xmlNode.createTextNode(sprintf('%f', position(1))));
                jointPositionYElement = xmlNode.createElement('Y');
                jointPositionYElement.appendChild(xmlNode.createTextNode(sprintf('%f', position(2))));
            
                jointElement.appendChild(jointPositionXElement);
                jointElement.appendChild(jointPositionYElement);               
            else
                error('Invalid format for the POSE.');
            end
            
            poseElement.appendChild(jointElement);
        end      
    end
    frameElement.appendChild(poseElement);
        
    errorElement = xmlNode.createElement('Error');
    if (nargin < 6)    
        errorElement.appendChild(xmlNode.createTextNode(DEFAUL_EMPTY_STRING)); 
    else
        errorElement.appendChild(xmlNode.createTextNode(sprintf('%f', error(poses(I), true_poses(I)))));         
    end
    frameElement.appendChild(errorElement);
    
    xmlRootNode.appendChild(frameElement);
end
 
xmlwrite(filename,xmlNode);

ok = 1;
