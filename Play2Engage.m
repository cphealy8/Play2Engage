function varargout = Play2Engage(varargin)
% PLAY2ENGAGE MATLAB code for Play2Engage.fig
%      PLAY2ENGAGE, by itself, creates a new PLAY2ENGAGE or raises the existing
%      singleton*.
%
%      H = PLAY2ENGAGE returns the handle to a new PLAY2ENGAGE or the handle to
%      the existing singleton*.
%
%      PLAY2ENGAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAY2ENGAGE.M with the given input arguments.
%
%      PLAY2ENGAGE('Property','Value',...) creates a new PLAY2ENGAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Play2Engage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Play2Engage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Play2Engage

% Last Modified by GUIDE v2.5 03-Jun-2020 09:03:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Play2Engage_OpeningFcn, ...
                   'gui_OutputFcn',  @Play2Engage_OutputFcn, ...
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


% --- Executes just before Play2Engage is made visible.
function Play2Engage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Play2Engage (see VARARGIN)

% Choose default command line output for Play2Engage
handles.output = hObject;
handles.keptCards = {};
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Play2Engage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Play2Engage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path]=uigetfile('*.xlsx');

% Catch errors when the user cancels the deck selection
if file == 0 
    return
end

deckDir = fullfile(path,file);
[~,~,raw] = xlsread(deckDir); 

catString = raw(1,:);
categories = regexprep(catString,' +','_');
cards = raw(2:end,:);

for n=1:length(categories)
    opns = cards(:,n);
    opns(cellfun(@(opns) any(isnan(opns)),opns))=[];
    deck.(categories{n}) = opns;
end


handles.deck = deck;
handles.cats = categories;
set(handles.AttributeBox,'String',catString);
set(handles.DealButton,'Enable','On');
set(handles.Handbox,'Enable','On');
guidata(hObject,handles);



% --- Executes on selection change in AttributeBox.
function AttributeBox_Callback(hObject, eventdata, handles)
% hObject    handle to AttributeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AttributeBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AttributeBox


% --- Executes during object creation, after setting all properties.
function AttributeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AttributeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DealButton.
function DealButton_Callback(hObject, eventdata, handles)
% hObject    handle to DealButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Generate a random handle
deck = handles.deck;
categories = handles.cats;
nFields = numel(fieldnames(deck));

% draw a random card for each field
for n=1:nFields
    cards = deck.(categories{n});
    draw(n) = randsample(cards,1);
    clear cards
end

set(handles.Handbox,'String',draw);
guidata(hObject,handles);




% --- Executes on selection change in Handbox.
function Handbox_Callback(hObject, eventdata, handles)
% hObject    handle to Handbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Handbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Handbox

% contents = cellstr(get(hObject,'String'));
% userSelect = contents{get(hObject,'Value')};
% 
% handles.selection = userSelect;
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Handbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Handbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in keepbutton.
function keepbutton_Callback(hObject, eventdata, handles)
% hObject    handle to keepbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
linebreak = {'- - - - - -'};
hand = cellstr(handles.Handbox.String);
userSelect = hand(handles.Handbox.Value);
newItems = [userSelect; linebreak];

handles.keptCards = [handles.keptCards; newItems];

set(handles.keepbox,'String',handles.keptCards);
guidata(hObject,handles);



% --- Executes on selection change in keepbox.
function keepbox_Callback(hObject, eventdata, handles)
% hObject    handle to keepbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns keepbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from keepbox
a = 1;


% --- Executes during object creation, after setting all properties.
function keepbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keepbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
