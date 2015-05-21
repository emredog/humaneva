function varargout = HumanEva(varargin)
% HUMANEVA M-file for HumanEva.fig
%      HUMANEVA, by itself, creates a new HUMANEVA or raises the existing
%      singleton*.
%
%      H = HUMANEVA returns the handle to a new HUMANEVA or the handle to
%      the existing singleton*.
%
%      HUMANEVA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HUMANEVA.M with the given input arguments.
%
%      HUMANEVA('Property','Value',...) creates a new HUMANEVA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HumanEva_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HumanEva_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HumanEva

% Last Modified by GUIDE v2.5 29-Jun-2006 01:45:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HumanEva_OpeningFcn, ...
                   'gui_OutputFcn',  @HumanEva_OutputFcn, ...
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


% --- Executes just before HumanEva is made visible.
function HumanEva_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HumanEva (see VARARGIN)

% Choose default command line output for HumanEva
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HumanEva wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HumanEva_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in AllData.
function AllData_Callback(hObject, eventdata, handles)
% hObject    handle to AllData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HumanEva_Dataset_Viewer; 

% --- Executes on button press in TrainData.
function TrainData_Callback(hObject, eventdata, handles)
% hObject    handle to TrainData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HumanEva_Dataset_Viewer(he_dataset('HumanEvaI','Train')); 

% --- Executes on button press in ValidationData.
function ValidationData_Callback(hObject, eventdata, handles)
% hObject    handle to ValidationData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HumanEva_Dataset_Viewer(he_dataset('HumanEvaI','Validate')); 

% --- Executes on button press in TestData.
function TestData_Callback(hObject, eventdata, handles)
% hObject    handle to TestData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HumanEva_Dataset_Viewer(he_dataset('HumanEvaI','Test')); 

fig = DatabasePlayerGUI;
pause;


