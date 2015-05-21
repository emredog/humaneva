function [poses, frames, cam, dset, errors] = importXML(this, filename)
% importXML Imports XML file with results.
%
% Syntax: 
%       [poses] = importXML(this, filename);
%       [poses, frames] = importXML(this, filename);
%       [poses, frames, cam] = importXML(this, filename);
%       [poses, frames, cam, dset] = importXML(this, filename);
%       [poses, frames, cam, dset, errors] = importXML(this, filename);
%
%   Where,
%       POSES  - 1xN array of BODY_POSE objects
%       FRAMES - 1xN array of integer frame numbers corresponding to the
%                POSES
%       CAM    - String designating which camera view was used to obtain
%                the pose.
%       DSET   - HE_DATASET object, designating the sequence from which the
%                data was taken 
%       ERRORS - 1xN array of positive reals corresponding to the errors
%                for the POSES (as compared to the ground truth). If frame
%                does not contain a valid error, -1 will be returned. 
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

if (~exist(filename))
    error('FILENAME should be an absolute path to a valid XML file.');
end

% Get the XML document and root node
xmlDoc  = xmlread(filename);
xmlRoot = xmlDoc.getDocumentElement;
   
if (nargout > 3)
    attributes = parseAttributes(xmlRoot);
    
    dset = he_dataset;
    dset = dset(1);
    
    for A=1:length(attributes)
        set(dset, attributes(A).Name, attributes(A).Value);
    end
end

if (nargout > 2)
    cam = getNodeDataString(xmlRoot, 'Camera');
    if (strcmp(cam, 'N/A'))
        cam = '';
    end
end

if (xmlRoot.hasChildNodes)
    % Get all the frames
    frameNodes = xmlRoot.getElementsByTagName('Frame'); 
    numFrameNodes = frameNodes.getLength;

    % For every frame 
    for F = 1:numFrameNodes
        % Get frame node
        theFrame = frameNodes.item(F-1);
        
        % Read frame number if requested        
        if (nargout > 1)
            frames(F) = getNodeDataNumber(theFrame, 'Number');
        end
        
        % Read pose for the frame if requested
        if (nargout > 0)
            poses(F) = body_pose;

            % Get pose node
            thePose = theFrame.getElementsByTagName('Pose').item(0);
    
            % Get joint nodees for the pose;
            jointNodes = thePose.getElementsByTagName('Joint');            
            numJointNodes = jointNodes.getLength;
            
            % Loop over all the joints and read data
            for J = 1:numJointNodes
                theJoint     = jointNodes.item(J-1);
            	jointName    = getNodeDataString(theJoint, 'Name');
                jointEnabled = getNodeDataNumber(theJoint, 'Enabled');
                jointX       = getNodeDataNumber(theJoint, 'X');
                jointY       = getNodeDataNumber(theJoint, 'Y');
                jointZ       = getNodeDataNumber(theJoint, 'Z');
                
                poses(F) = set(poses(F), jointName, [jointX, jointY, jointZ]);
                poses(F) = set(poses(F), [jointName, 'Enabled'], logical(jointEnabled));  
            end
        end
        
        % Read error for the frame if requested
        if (nargout > 4)
            err = getNodeDataNumber(theFrame, 'Error');  
            if (~isempty(err))
                if (err >= 0.0)
                    errors(F) = err;
                else
                    errors(F) = -1;                
                end
            else
                errors(F) = -1;                             
            end
        end
    end    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%     getNodeDataString
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result] = getNodeDataString(theNode, name)

result = char(theNode.getElementsByTagName(name).item(0).getChildNodes.item(0).getData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%     getNodeDataNumber
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [result] = getNodeDataNumber(theNode, name)

result = str2num(theNode.getElementsByTagName(name).item(0).getChildNodes.item(0).getData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%     parseAttributes
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [attributes] = parseAttributes(theNode)

attributes = [];
if theNode.hasAttributes
    theAttributes = theNode.getAttributes;
    numAttributes = theAttributes.getLength;
    allocCell = cell(1, numAttributes);
    attributes = struct('Name', allocCell, 'Value', allocCell);

    for count = 1:numAttributes
        attrib = theAttributes.item(count-1);
        attributes(count).Name = char(attrib.getName);
        attributes(count).Value = char(attrib.getValue);
    end
end
