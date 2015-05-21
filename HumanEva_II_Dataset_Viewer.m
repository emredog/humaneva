function varargout = HumanEva_II_Dataset_Viewer(varargin)
% HUMANEVA_II_DATASET_VIEWER M-file for HumanEva_II_Dataset_Viewer.fig
%      HUMANEVA_II_DATASET_VIEWER, by itself, creates a new instance of the 
%      viewr or raises the existing singleton*.
%
%      HUMANEVA_II_DATASET_VIEWER(dataset) will launch the viewer for a given 
%      dataset or data sub-set. Launching the viewer without arguments will
%      result in all the HumanEva dataset being loaded.
% 
%      Examples:
%
%           HumanEva_II_Dataset_Viewer; 
%               % Loads the full HumanEvaII test dataset
%           HumanEva_II_Dataset_Viewer(he_dataset('HumanEvaII','Test')); 
%               % Loads the Trest data only of the HumanEvaII dataset
%           HumanEva_II_Dataset_Viewer(he_dataset('HumanEvaII','All')); 
%               % Loads the full HumanEvaII dataset (same as call without
%               % arguments
%
% See also: DATASET
%
% Written by: Leonid Sigal 
% Revision:   1.0
% Date:       3/16/2007
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

% Add paths to the toolboxes
addpath('./TOOLBOX_calib/');
addpath('./TOOLBOX_common/');
addpath('./TOOLBOX_dxAvi/');
addpath('./TOOLBOX_readc3d/');   

% Standard GUI code by Matlab
warning off backtrace;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HumanEva_II_Dataset_Viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @HumanEva_II_Dataset_Viewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HumanEva_II_Dataset_Viewer is made visible.
function HumanEva_II_Dataset_Viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HumanEva_II_Dataset_Viewer (see VARARGIN)

% Choose default command line output for HumanEva_II_Dataset_Viewer
handles.output = hObject;

% Set additional custom variables that are needed by the GUI.
%     handles.input is the dataset by default full HumanEva dataset.
if (length(varargin) > 1)
    error('Too many arguments to the function');
elseif (length(varargin) == 1)
    handles.input = varargin{1};
else
    handles.input = he_dataset('HumanEvaII');
end

% Update handles structure
guidata(hObject, handles);

% Setup the Subject drop-down box
if (~isempty(handles.input))
    set(handles.Subject, 'String', unique(get(handles.input, 'SubjectName')));
end
% Get selected Subject 
Subject          = get(handles.Subject, 'String');
SubjectIndex     = get(handles.Subject, 'Value');
SelectedSubject  = Subject{SubjectIndex};
% Setup the Action/Activity drop-down box for a selectes Subject
if (~isempty(handles.input))
    database_subset = query(handles.input, 'SubjectName', SelectedSubject);
    set(handles.Activity, 'String', unique(get(database_subset, 'ActionType')));
end
% Get selected Activity/Action
Activity         = get(handles.Activity, 'String');
ActivityIndex    = get(handles.Activity, 'Value');
SelectedActivity = Activity{ActivityIndex};
% Setup the Trial drop-down box for a selectes Subject and Action
if (~isempty(handles.input))
    database_subset = query(handles.input, 'SubjectName', SelectedSubject , 'ActionType', SelectedActivity);
    set(handles.Trial, 'String', unique(get(database_subset, 'Trial')));
end
% Load the selected sequence
loadSequence(handles);
    
    
% --- Outputs from this function are returned to the command line.
function varargout = HumanEva_II_Dataset_Viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Subject.
function Subject_Callback(hObject, eventdata, handles)
% hObject    handle to Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Subject contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Subject

% Adjust the Subject name based on the selection
if (~isempty(handles.input))
    set(hObject, 'String', unique(get(handles.input,'SubjectName')));
end

% Get selected Subject 
Subject          = get(handles.Subject, 'String');
SubjectIndex     = get(handles.Subject, 'Value');
SelectedSubject  = Subject{SubjectIndex};

% Setup the Action/Activity drop-down box for a selectes Subject
if (~isempty(handles.input))
    database_subset = query(handles.input, 'SubjectName', SelectedSubject);
    set(handles.Activity, 'String', unique(get(database_subset, 'ActionType')));
    set(handles.Activity, 'Value', 1);
end

% Get selected Activity/Action
Activity         = get(handles.Activity, 'String');
ActivityIndex    = get(handles.Activity, 'Value');
SelectedActivity = Activity{ActivityIndex};

% Setup the Trial drop-down box for a selectes Subject and Action
if (~isempty(handles.input))
    database_subset = query(handles.input, 'SubjectName', SelectedSubject , 'ActionType', SelectedActivity);
    set(handles.Trial, 'String', unique(get(database_subset, 'Trial')));
    set(handles.Trial, 'Value', 1);
end

% Load the selected sequence
loadSequence(handles);


% --- Executes during object creation, after setting all properties.
function Subject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Activity.
function Activity_Callback(hObject, eventdata, handles)
% hObject    handle to Activity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Activity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Activity

% Get selected Subject 
Subject          = get(handles.Subject, 'String');
SubjectIndex     = get(handles.Subject, 'Value');
SelectedSubject  = Subject{SubjectIndex};

% Adjust the Action/Activity type based on the selection
if (~isempty(handles.input))
    database_subset = query(handles.input, 'SubjectName', SelectedSubject);
    set(hObject, 'String', unique(get(database_subset, 'ActionType')));
end

% Get selected Activity/Action
Activity         = get(handles.Activity, 'String');
ActivityIndex    = get(handles.Activity, 'Value');
SelectedActivity = Activity{ActivityIndex};

% Setup the Trial drop-down box for a selectes Subject and Action
if (~isempty(handles.input))
    database_subset = query(handles.input, 'SubjectName', SelectedSubject , 'ActionType', SelectedActivity);
    set(handles.Trial, 'String', unique(get(database_subset, 'Trial')));
    set(handles.Trial, 'Value', 1);
end

% Load the selected sequence
loadSequence(handles);


% --- Executes during object creation, after setting all properties.
function Activity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Activity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Trial.
function Trial_Callback(hObject, eventdata, handles)
% hObject    handle to Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Trial contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Trial

% Get selected Subject 
Subject          = get(handles.Subject, 'String');
SubjectIndex     = get(handles.Subject, 'Value');
SelectedSubject  = Subject{SubjectIndex};

% Get selected Activity/Action
Activity         = get(handles.Activity, 'String');
ActivityIndex    = get(handles.Activity, 'Value');
SelectedActivity = Activity{ActivityIndex};

% Adjust the Trial based on the selection
if (~isempty(handles.input))
    database_subset = query(handles.input, 'SubjectName', SelectedSubject , 'ActionType', SelectedActivity);
    set(hObject, 'String', unique(get(database_subset, 'Trial')));
end

% Load the selected sequence
loadSequence(handles);


% --- Executes during object creation, after setting all properties.
function Trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MocapOnly.
function MocapOnly_Callback(hObject, eventdata, handles)
% hObject    handle to MocapOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MocapOnly

% Change the display preferences based on the selection
set(handles.VideoOnly,     'Value', 0);
set(handles.MocapAndVideo, 'Value', 0);
set(handles.MocapOnly,     'Value', 1);

% Update the display
updateDisplay(handles);


% --- Executes on button press in VideoOnly.
function VideoOnly_Callback(hObject, eventdata, handles)
% hObject    handle to VideoOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoOnly

% Change the display preferences based on the selection
set(handles.MocapOnly,     'Value', 0);
set(handles.MocapAndVideo, 'Value', 0);
set(handles.VideoOnly,     'Value', 1);

% Update the display
updateDisplay(handles);


% --- Executes on button press in MocapAndVideo.
function MocapAndVideo_Callback(hObject, eventdata, handles)
% hObject    handle to MocapAndVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MocapAndVideo

% Change the display preferences based on the selection
set(handles.VideoOnly,     'Value', 0);
set(handles.MocapOnly,     'Value', 0);
set(handles.MocapAndVideo, 'Value', 1);

% Update the display
updateDisplay(handles);


% --- Executes on slider movement.
function FrameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Set current frame to the value of the slider. 
global FRAME;
FRAME = round(get(hObject, 'Value'));

% Adjust the slider based on selection.
set(handles.FrameEdit, 'String', num2str(round(get(hObject, 'Value'))));
set(handles.FrameEdit, 'String', num2str(round(get(hObject, 'Max'))));

% Update the display
updateDisplay(handles);


% --- Executes during object creation, after setting all properties.
function FrameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FRAME;
global PLAYING;

if (isempty(PLAYING) || (PLAYING == 0))
    PLAYING = 1;

    while ((FRAME < get(handles.FrameSlider, 'Max')) && PLAYING)
        FRAME = FRAME + 1;
        updateDisplay(handles);
        pause(0.1);
    end   
else
    PLAYING = 0;
end


% --- Executes on button press in Fwd.
function Fwd_Callback(hObject, eventdata, handles)
% hObject    handle to Fwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add 1 to the current frame counter
global FRAME;
if (FRAME < get(handles.FrameSlider, 'Max'))
    FRAME = FRAME + 1;
end

% Update the display
updateDisplay(handles);


% --- Executes on button press in FastFwd.
function FastFwd_Callback(hObject, eventdata, handles)
% hObject    handle to FastFwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add 20 to the current frame counter
global FRAME;
if (FRAME < (get(handles.FrameSlider, 'Max')-20))
    FRAME = FRAME + 20;
end

% Update the display
updateDisplay(handles);


% --- Executes on button press in Bwd.
function Bwd_Callback(hObject, eventdata, handles)
% hObject    handle to Bwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Subtract 1 from the current frame counter
global FRAME;
if (FRAME > get(handles.FrameSlider, 'Min'))
    FRAME = FRAME - 1;
end

% Update the display
updateDisplay(handles);


% --- Executes on button press in FastBwd.
function FastBwd_Callback(hObject, eventdata, handles)
% hObject    handle to FastBwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Subtract 20 from the current frame counter
global FRAME;
if (FRAME > (get(handles.FrameSlider, 'Min')+20))
    FRAME = FRAME - 20;
end

% Update the display
updateDisplay(handles);


function FrameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameEdit as text
%        str2double(get(hObject,'String')) returns contents of FrameEdit as a double


% --- Executes during object creation, after setting all properties.
function FrameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FrameMaxEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FrameMaxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameMaxEdit as text
%        str2double(get(hObject,'String')) returns contents of FrameMaxEdit as a double


% --- Executes during object creation, after setting all properties.
function FrameMaxEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameMaxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global FRAME;
clear global PLAYING;

global ImageStream;
global MocapStream;
global ImageStream_Enabled;
global MocapStream_Enabled;

for I = 1:length(ImageStream_Enabled)
    if (ImageStream_Enabled(I))
        fprintf('Closing image stream %d.\n', I);        
        % FRAME = round(mean([get(handles.FrameSlider, 'Min'), get(handles.FrameSlider, 'Max')]));
        % cur_image(ImageStream(I), FRAME);        
        pause(0.2);
        close(ImageStream(I));
    end
end

clear global ImageStream_Enabled;
clear global ImageStream_Enabled;
clear global MocapStream;
clear global MocapStream;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    These are the main function that are accessed by most of the GUI    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = loadSequence(handles)

% Get selected Subject
Subject          = get(handles.Subject, 'String');
SubjectIndex     = get(handles.Subject, 'Value');
SelectedSubject  = Subject{SubjectIndex};

% Get selected Activity/Action
Activity         = get(handles.Activity, 'String');
ActivityIndex    = get(handles.Activity, 'Value');
SelectedActivity = Activity{ActivityIndex};

% Get selected Trial
Trial            = get(handles.Trial, 'String');
TrialIndex       = get(handles.Trial, 'Value');
SelectedTrial    = Trial{TrialIndex};

% Select the relavent sequences from the current dataset
database_subset = query(handles.input, 'SubjectName', SelectedSubject , 'ActionType', SelectedActivity, 'Trial', SelectedTrial);

% Load the synchronized streams of data
global ImageStream;
global MocapStream;
global ImageStream_Enabled;
global MocapStream_Enabled;
[ImageStream, ImageStream_Enabled, MocapStream, MocapStream_Enabled] = sync_stream(database_subset(1));

set(handles.VideoOnly,     'Value', 0);
set(handles.MocapOnly,     'Value', 0);
set(handles.MocapAndVideo, 'Value', 1);    
set(handles.MocapOnly,     'Visible', 'on');
set(handles.MocapAndVideo, 'Visible', 'on');
set(handles.VideoOnly,     'Visible', 'on');    

% Based on the selected sequences set the range of frames and the current 
% frame to render.
global FRAME;
max_frame = get(database_subset, 'FrameEnd');
max_frame = max([max_frame{:}]);
FRAME = get(database_subset, 'FrameStart');
FRAME = min([FRAME{:}]);

set(handles.FrameSlider, 'Min', FRAME);
set(handles.FrameSlider, 'Max', max_frame);
set(handles.FrameSlider, 'Value', FRAME);

set(handles.FrameMaxEdit, 'String', num2str(max_frame));
set(handles.FrameEdit, 'String', num2str(FRAME));

% Update the display
updateDisplay(handles);

% If data was playing, turn the play mode off.
global PLAYING;
PLAYING = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = updateDisplay(handles)

global FRAME;
global ImageStream;
global MocapStream;
global ImageStream_Enabled;
global MocapStream_Enabled;

% For simplicity collect all the display axes handles to one array so that
% we can iterate over them.
ListOfAxisHandles = [handles.AxisC1, handles.AxisC2, handles.AxisC3, handles.AxisC4];

% Get selected Subject
Subject          = get(handles.Subject, 'String');
SubjectIndex     = get(handles.Subject, 'Value');
SelectedSubject  = Subject{SubjectIndex};

% Get selected Activity/Action
Activity         = get(handles.Activity, 'String');
ActivityIndex    = get(handles.Activity, 'Value');
SelectedActivity = Activity{ActivityIndex};

% Get selected Trial
Trial            = get(handles.Trial, 'String');
TrialIndex       = get(handles.Trial, 'Value');
SelectedTrial    = Trial{TrialIndex};

set(handles.FrameSlider, 'Value', FRAME);
set(handles.FrameEdit, 'String', num2str(FRAME));

for A = 1:length(ListOfAxisHandles)-length(ImageStream)
    set(ListOfAxisHandles(A), 'Visible', 'off');
end

% For axis A display the associated image from the video stream 
for A = 1:length(ListOfAxisHandles)
    set(ListOfAxisHandles(A), 'Visible', 'on');

    % Set current axes to A
    axes(ListOfAxisHandles(A));
    
    % If image view is disabled, show blank image
    if (get(handles.MocapOnly, 'Value'))
        imshow(zeros(480,640));
    else
        % otherwise check if the image stream is enabled
        if (ImageStream_Enabled(A))
            % if it is, get current frame and display
            cur_image(ImageStream(A), FRAME);
        else
            % else draw red crosshairs telling the user that there
            % is an error in the image stream
            imshow(zeros(480,640));        
            hold on;
            plot([640,1], [1,480], '-r', 'LineWidth', [10]);
            plot([1,640], [1,480], '-r', 'LineWidth', [10]);       
            hold off;
            axis off;
        end
    end
end
    
if (~get(handles.VideoOnly, 'Value'))  % If mocap is enabled in GUI
    % If MoCap display enabled
    if (MocapStream_Enabled)  
        % Get current MoCap frame
        [MocapStream, stateXforms, ValidPose] = cur_frame(MocapStream, FRAME, 'body_pose_xforms');
        [MocapStream, stateJoints, ValidPose] = cur_frame(MocapStream, FRAME, 'body_pose');
        [MocapStream, limbparams, ValidPose]  = cur_frame(MocapStream, FRAME, 'body_params');
        [MocapStream, limblengths, ValidPose] = cur_frame(MocapStream, FRAME, 'body_lengths');
        
        % if there is an error in MoCap data
        if (~ValidPose)
            % display blue cross-hairs to show users that there is an error                                         
            for A = 1:length(ListOfAxisHandles)
                axes(ListOfAxisHandles(A));
                hold on;
                plot([320,320], [1,480], '-b', 'LineWidth', [5]);
                plot([1,640], [240,240], '-b', 'LineWidth', [5]);       
                hold off;            
            end        
        else
            
            for A = 1:length(ListOfAxisHandles)
                % load calibration
                calfilename = ['../' SelectedSubject '/Calibration_Data/C' num2str(A) '.cal'];
                
                [stateJoints2D] = project2d(stateJoints, calfilename); 
                
                % set current axis to A
                axes(ListOfAxisHandles(A));
                
                hold on;
                
                % Render body parts
                RenderedCylinder(limbparams(1,1), limbparams(1,2), limblengths(1), ...
                    get(stateXforms, 'torso') *  ...
                    [diag([limbparams(1,3), limbparams(1,4), 1]), [0;0;0]; 0,0,0,1], calfilename);
                RenderedCylinder(limbparams(2,1), limbparams(2,2), limblengths(3), ...
                    get(stateXforms, 'upperLLeg') * ...
                    [diag([limbparams(2,3), limbparams(2,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(3,1), limbparams(3,2), limblengths(4), ...
                    get(stateXforms, 'lowerLLeg') * ...
                    [diag([limbparams(3,3), limbparams(3,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(4,1), limbparams(4,2), limblengths(7), ...
                    get(stateXforms, 'upperRLeg') * ...
                    [diag([limbparams(4,3), limbparams(4,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(5,1), limbparams(5,2), limblengths(8), ...
                    get(stateXforms, 'lowerRLeg') * ...
                    [diag([limbparams(5,3), limbparams(5,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(6,1), limbparams(6,2), -limblengths(11), ...
                    get(stateXforms, 'upperLArm') * ...
                    [diag([limbparams(6,3), limbparams(6,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(7,1), limbparams(7,2), -limblengths(12), ...
                    get(stateXforms, 'lowerLArm') * ...
                    [diag([limbparams(7,3), limbparams(7,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(8,1), limbparams(8,2), -limblengths(15), ...
                    get(stateXforms, 'upperRArm') * ... 
                    [diag([limbparams(8,3), limbparams(8,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(9,1), limbparams(9,2), -limblengths(16), ...
                    get(stateXforms, 'lowerRArm') * ...
                    [diag([limbparams(9,3), limbparams(9,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    
                RenderedCylinder(limbparams(10,1), limbparams(10,2), limblengths(18), ...
                    get(stateXforms, 'head') * ...
                    [diag([limbparams(10,3), limbparams(10,4), 1]), [0;0;0]; 0,0,0,1], calfilename);    

                % Render joints (proximal)
                plot([  stateJoints2D.torsoProximal(1)    , ... 
                        stateJoints2D.upperLArmProximal(1), ...
                        stateJoints2D.lowerLArmProximal(1), ...
                        stateJoints2D.upperRArmProximal(1), ...
                        stateJoints2D.lowerRArmProximal(1), ...
                        stateJoints2D.upperLLegProximal(1), ...
                        stateJoints2D.lowerLLegProximal(1), ...
                        stateJoints2D.upperRLegProximal(1), ...
                        stateJoints2D.lowerRLegProximal(1), ...
                        stateJoints2D.headProximal(1)          ], ...
                     [  stateJoints2D.torsoProximal(2)    , ... 
                        stateJoints2D.upperLArmProximal(2), ...
                        stateJoints2D.lowerLArmProximal(2), ...
                        stateJoints2D.upperRArmProximal(2), ...
                        stateJoints2D.lowerRArmProximal(2), ...
                        stateJoints2D.upperLLegProximal(2), ...
                        stateJoints2D.lowerLLegProximal(2), ...
                        stateJoints2D.upperRLegProximal(2), ...
                        stateJoints2D.lowerRLegProximal(2), ...
                        stateJoints2D.headProximal(2)          ], ...
                     '.g', 'LineWidth', [4]);   
                % Render joints (distal)    
                plot([  stateJoints2D.torsoDistal(1)      , ...
                        stateJoints2D.upperLArmDistal(1)  , ...
                        stateJoints2D.lowerLArmDistal(1)  , ...
                        stateJoints2D.upperRArmDistal(1)  , ...
                        stateJoints2D.lowerRArmDistal(1)  , ...
                        stateJoints2D.upperLLegDistal(1)  , ...
                        stateJoints2D.lowerLLegDistal(1)  , ...
                        stateJoints2D.upperRLegDistal(1)  , ...
                        stateJoints2D.lowerRLegDistal(1)  , ...
                        stateJoints2D.headDistal(1)            ], ...
                     [  stateJoints2D.torsoDistal(2)      , ...
                        stateJoints2D.upperLArmDistal(2)  , ...
                        stateJoints2D.lowerLArmDistal(2)  , ...
                        stateJoints2D.upperRArmDistal(2)  , ...
                        stateJoints2D.lowerRArmDistal(2)  , ...
                        stateJoints2D.upperLLegDistal(2)  , ...
                        stateJoints2D.lowerLLegDistal(2)  , ...
                        stateJoints2D.upperRLegDistal(2)  , ...
                        stateJoints2D.lowerRLegDistal(2)  , ...
                        stateJoints2D.headDistal(2)            ], ...                        
                     '.m', 'LineWidth', [2]);                   
                 
                hold off;
            end            
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = RenderedCylinder(baseDiam, topDiam, length, transform, calibfilename)

% read calibration
[fc, cc, alpha_c, kc, Rc_ext, omc_ext, Tc_ext] = ReadSpicaCalib(calibfilename);

% render the limb as a cylinder.
[x,y,z] = cylinder([baseDiam, topDiam], 40);
z = z .* length;
xyz1 = transform * [x(1,:); y(1,:); z(1,:); ones(size(z(1,:)))];
xyz2 = transform * [x(2,:); y(2,:); z(2,:); ones(size(z(1,:)))];
xyz1(4,:) = [];
xyz2(4,:) = [];
[Xp1,dxpdom,dxpdT,dxpdf,dxpdc,dxpdk,dxpdalpha] = ...
           project_points2(xyz1,omc_ext,Tc_ext,fc,cc,kc,alpha_c);            
[Xp2,dxpdom,dxpdT,dxpdf,dxpdc,dxpdk,dxpdalpha] = ...
           project_points2(xyz2,omc_ext,Tc_ext,fc,cc,kc,alpha_c);            
x = [Xp1(1,:); Xp2(1,:)];
y = [Xp1(2,:); Xp2(2,:)];
z = ones(size(x));
% get a convex hull of all the points inside the cylinder
k = convhull(x,y);
plot(x(k),y(k),'r-')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


