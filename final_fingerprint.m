function varargout = final_fingerprint(varargin)
% FINAL_FINGERPRINT MATLAB code for final_fingerprint.fig
%      FINAL_FINGERPRINT, by itself, creates a new FINAL_FINGERPRINT or raises the existing
%      singleton*.
%
%      H = FINAL_FINGERPRINT returns the handle to a new FINAL_FINGERPRINT or the handle to
%      the existing singleton*.
%
%      FINAL_FINGERPRINT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_FINGERPRINT.M with the given input arguments.
%
%      FINAL_FINGERPRINT('Property','Value',...) creates a new FINAL_FINGERPRINT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_fingerprint_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_fingerprint_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final_fingerprint

% Last Modified by GUIDE v2.5 11-Apr-2019 15:29:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_fingerprint_OpeningFcn, ...
                   'gui_OutputFcn',  @final_fingerprint_OutputFcn, ...
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


% --- Executes just before final_fingerprint is made visible.
function final_fingerprint_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_fingerprint (see VARARGIN)


% Choose default command line output for final_fingerprint
handles.output = hObject;

% Update handles structure
guidata(hObject, handles)

% UIWAIT makes final_fingerprint wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_fingerprint_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.minSize= 61719;

load('Data.mat','c');

Avg_normal  =c('Avg_normal') ;
Avg_stenosis=c('Avg_stenosis');
Avg_ASD= c('AVg_ASD') ;
normal_peaks= c('normal_peaks');
stenosis_peaks= c('stenosis_peaks');
ASD_peaks=c('ASD_peaks');

%browse for test signal
[filename,pathname] = uigetfile({'*.mp3'},'File Selector');
fullpathname = strcat(pathname, filename);
[test_signal,test_fs] = audioread(fullpathname);
test_signal = test_signal(1:handles.minSize,1);
handles.minSize
%test_align = test_signal(1:handles.minSize,1);
[test_signalS,test_signalW,test_signalT] = spectrogram(test_signal,1000,100);
%axes(handles.axes1);
plot(handles.axes1,10*log10(abs(spectrogram(test_signal,'yaxis'))));
[testSpectro_rows, testSpectro_columns] = size(test_signalS);
for i=1:testSpectro_columns
    [test_pks,test_idx] = findpeaks(abs(test_signalS(:,i)));
    [test_rows,test_columns] = size(test_pks);
    test_peaks(1:test_rows,i) = test_pks;
end

[ test_peaks,normal_peaks ] = check( test_peaks, normal_peaks );
cc = corrcoef(test_peaks, normal_peaks); 
arr(1) = abs(cc(1,2))

[ test_peaks,stenosis_peaks ] = check( test_peaks, stenosis_peaks );
cc = corrcoef(test_peaks, stenosis_peaks); 
arr(2) = abs(cc(1,2))


[ test_peaks,ASD_peaks ] = check( test_peaks, ASD_peaks )
cc = corrcoef(test_peaks, ASD_peaks); 
arr(3) = abs(cc(1,2))

max_coeff=max(arr)
set(handles.rcoeff,'string',max_coeff);
if max_coeff < 0.4 
    text= 'Not a HeartBeat';
elseif max_coeff==arr(1)
    text = 'Normal HeartBeat';
    plot(handles.axes2,10*log10(abs(spectrogram(Avg_normal,'yaxis'))));
elseif max_coeff==arr(2)
    text = 'Stenosis';
    plot(handles.axes2,10*log10(abs(spectrogram(Avg_stenosis,'yaxis'))));

else 
    text = 'Atrial Septal Defect';
    plot(handles.axes2,10*log10(abs(spectrogram( Avg_ASD,'yaxis'))));

end 
set(handles.edit4,'string',text);
guidata(hObject, handles)

    






function rcoeff_Callback(hObject, eventdata, handles)
% hObject    handle to rcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rcoeff as text
%        str2double(get(hObject,'String')) returns contents of rcoeff as a double


% --- Executes during object creation, after setting all properties.
function rcoeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
