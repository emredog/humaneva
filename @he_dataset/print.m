function [] = print(this)
% PRINT Print the contents of HE_DATASET object or array of objects.
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

if (prod(size(this)) ~= length(this))
    error('Function requires an array of HE_DATASET objects as an input.');
end

maxDatasetName     = 0;
maxDatasetBasePath = 0;
maxSubjectName     = 0;
maxActionType      = 0;
maxTrial           = 0;
maxFrameEnd        = 0;
maxFrameStart      = 0;
maxPartition       = 0;
for I = 1:length(this)
    maxDatasetName     = max([maxDatasetName, length(this(I).DatasetName)]);        
    maxDatasetBasePath = max([maxDatasetBasePath, length(this(I).DatasetBasePath)]);  
    maxSubjectName     = max([maxSubjectName, length(this(I).SubjectName)]);
    maxActionType      = max([maxActionType, length(this(I).ActionType)]);
    maxTrial           = max([maxTrial, length(this(I).Trial)]);
    maxFrameEnd        = max([maxFrameEnd, length(num2str(this(I).FrameEnd))]);
    maxFrameStart      = max([maxFrameStart, length(num2str(this(I).FrameStart))]);
    maxPartition       = max([maxPartition, length(this(I).Partition)]);
end
maxDatasetName     = max([maxDatasetName, length('Dataset Name')]);
maxDatasetBasePath = max([maxDatasetBasePath, length('Dataset Path')]);
maxSubjectName     = max([maxSubjectName, length('Subject')]);
maxActionType      = max([maxActionType, length('Action')]);
maxTrial           = max([maxTrial, length('Trial')]);       
maxPartition       = max([maxTrial, length('Partition')]);   
    

display(['+' repmat('-', 1, maxDatasetName+2)     '+' ... 
             repmat('-', 1, maxDatasetBasePath+2) '+' ...
             repmat('-', 1, maxSubjectName+2)     '+' ...
             repmat('-', 1, maxActionType+2)      '+' ...
             repmat('-', 1, maxTrial+2)           '+' ...
             repmat('-', 1, maxFrameEnd+maxFrameStart+5) '+' ...
             repmat('-', 1, maxPartition+2) '+' ]);

eval(['fprintf(''| %' num2str(maxDatasetName) 's | %' num2str(maxDatasetBasePath) 's '', ''Dataset Name'', ''Dataset Path'')']);
eval(['fprintf(''| %' num2str(maxSubjectName) 's | %' num2str(maxActionType) 's | %' num2str(maxTrial) 's '', ''Subject'', ''Action'', ''Trial'')']);
eval(['fprintf(''| %' num2str(maxFrameStart+3+maxFrameEnd) 's '', ''Frames'')']);            
eval(['fprintf(''| %' num2str(maxPartition) 's |\n'', ''Partition'')']);            
         
display(['+' repmat('-', 1, maxDatasetName+2)     '+' ... 
             repmat('-', 1, maxDatasetBasePath+2) '+' ...
             repmat('-', 1, maxSubjectName+2)     '+' ...
             repmat('-', 1, maxActionType+2)      '+' ...
             repmat('-', 1, maxTrial+2)           '+' ...
             repmat('-', 1, maxFrameEnd+maxFrameStart+5) '+' ...
             repmat('-', 1, maxPartition+2) '+' ]);

for I = 1:length(this)
    eval(['fprintf(''| %' num2str(maxDatasetName) 's | %' num2str(maxDatasetBasePath) 's '', this(I).DatasetName, this(I).DatasetBasePath)']);
    eval(['fprintf(''| %' num2str(maxSubjectName) 's | %' num2str(maxActionType) 's | %' num2str(maxTrial) 's '', this(I).SubjectName, this(I).ActionType, this(I).Trial)']);
    eval(['fprintf(''| %' num2str(maxFrameStart) 's - %' num2str(maxFrameEnd) 's '', num2str(this(I).FrameStart), num2str(this(I).FrameEnd))']);            
    eval(['fprintf(''| %' num2str(maxPartition) 's |\n'', this(I).Partition)']);            
end

display(['+' repmat('-', 1, maxDatasetName+2)     '+' ... 
             repmat('-', 1, maxDatasetBasePath+2) '+' ...
             repmat('-', 1, maxSubjectName+2)     '+' ...
             repmat('-', 1, maxActionType+2)      '+' ...
             repmat('-', 1, maxTrial+2)           '+' ...
             repmat('-', 1, maxFrameEnd+maxFrameStart+5) '+' ...
             repmat('-', 1, maxPartition+2) '+' ]);


