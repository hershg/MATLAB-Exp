function varargout = DoseResponseFit(varargin)
%DOSERESPONSEFIT M-file for DoseResponseFit.fig
%      DOSERESPONSEFIT, by itself, creates a new DOSERESPONSEFIT or raises the existing
%      singleton*.
%
%      H = DOSERESPONSEFIT returns the handle to a new DOSERESPONSEFIT or the handle to
%      the existing singleton*.
%
%      DOSERESPONSEFIT('Property','Value',...) creates a new DOSERESPONSEFIT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to DoseResponseFit_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      DOSERESPONSEFIT('CALLBACK') and DOSERESPONSEFIT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in DOSERESPONSEFIT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2011 - 2012 MathWorks, Inc.
% Edit the above text to modify the response to help DoseResponseFit

% Last Modified by GUIDE v2.5 31-Oct-2012 14:37:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DoseResponseFit_OpeningFcn, ...
                   'gui_OutputFcn',  @DoseResponseFit_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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

% --- Executes just before DoseResponseFit is made visible.
function DoseResponseFit_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for DoseResponseFit
handles.output = hObject;
handles.scatter = []; 

% Update handles structure
guidata(hObject, handles);

%% Callback functions 
% --- Executes on button press in push_LoadData.
function push_LoadData_Callback(hObject, ~, handles)
% hObject    handle to push_LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Select Excel File(s)
[pname, fname] = uigetfile({'*.xls; *.xlsx', 'Excel File (.xls, .xlsx)'}, 'Select Data File') ;

if fname == 0  
   errordlg('Please select data file', 'Load Data Error')
else 
    % Import data
    handles.Data = dataset('xlsfile', fullfile(fname, pname)) ;
    
    % Get VarNames
    handles.varNames = handles.Data.Properties.VarNames ; 
        
    % Populate list with Treatment groups
    set(handles.popup_response, 'String', handles.varNames) ; 
    set(handles.popup_dose, 'String', handles.varNames) ; 
    set(handles.list_groupVars, 'String', handles.varNames) ; 
    
    % Get grpStr 
    handles.grpStr{1} = handles.Data.(handles.varNames{1}) ;
    
    % Enable Fit Data button
    set(handles.push_Fit, 'enable', 'on');
    
    % Set dose and response var to first variable
    handles.doseVar = handles.varNames{1} ;
    handles.responseVar = handles.varNames{1} ;
    handles.groupVars = handles.varNames{1} ;
    
    set(handles.popup_dose, 'Value', 1)
    set(handles.list_groupVars, 'Value', 1)
    set(handles.popup_response, 'Value', 1)
    
    % Set 
    set(handles.list_groupVars, 'max', length(handles.varNames) - 2)
    
    % Set file name
    set(handles.edit_fileString, 'string', fullfile(fname, pname), 'enable', 'on')
    handles.fileStr = fullfile(fname, pname) ; 
    
    % Plot Dose vs. Response grouped by Treatment group (Dose of Drug A)
    axes(handles.axes_plot); hold on; 
    try 
        cla
        handles.scatter = gscatter(handles.Data.(handles.doseVar), handles.Data.(handles.responseVar), handles.Data.(handles.groupVars)) ; 
    catch 
        msgbox('Invalid inputs', 'Default dose and response selection are incorrect', 'error') 
    end 
    
    % Enable reset button 
    set(handles.push_LoadData, 'enable', 'off') ; 

end 

guidata(hObject, handles) 

function edit_fileString_Callback(hObject, ~, handles)
% hObject    handle to edit_fileString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fileString as text
%        str2double(get(hObject,'String')) returns contents of edit_fileString as a double

msgbox('Use the Load Data button to load a new file', 'Load Data', 'help') 

set(hObject, 'string', handles.fileStr)

% --- Executes on selection change in popup_response.
function popup_response_Callback(hObject, ~, handles)
% hObject    handle to popup_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String')) ;
handles.responseVar = contents{get(hObject,'Value')} ; 


try
    if isfield(handles, 'scatter'), delete(handles.scatter) ; handles = rmfield(handles, 'scatter'); end
    hold on 
    handles.scatter = gscatter(handles.Data.(handles.doseVar), handles.Data.(handles.responseVar), handles.grpStr); 
catch
    msgbox('Invalid Dose or Response inputs', 'Invalid Input', 'error')
end
guidata(hObject, handles)

% --- Executes on selection change in popup_dose.
function popup_dose_Callback(hObject, ~, handles)
% hObject    handle to popup_dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String')) ;
handles.doseVar = contents{get(hObject,'Value')} ;

try
    if isfield(handles, 'scatter'), delete(handles.scatter) ; handles = rmfield(handles, 'scatter'); end
    hold on 
    handles.scatter = gscatter(handles.Data.(handles.doseVar), handles.Data.(handles.responseVar), handles.grpStr); 
catch
    msgbox('Invalid Dose or Response inputs', 'Invalid Input', 'error')
end
guidata(hObject, handles)

% --- Executes on selection change in list_groupVars.
function list_groupVars_Callback(hObject, ~, handles)
% hObject    handle to list_groupVars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'))  ;
handles.groupVars = contents(get(hObject,'Value'));

grpStr = cell(1,length(handles.groupVars));
for i = 1:length(handles.groupVars) 
    
    grpStr{i} = handles.Data.(handles.groupVars{i}) ;
end 
handles.grpStr = grpStr ;

try
    if isfield(handles, 'scatter'), delete(handles.scatter) ; handles = rmfield(handles, 'scatter'); end
    hold on 
    handles.scatter = gscatter(handles.Data.(handles.doseVar), handles.Data.(handles.responseVar), handles.grpStr); 
catch
    msgbox('Incorrect Dose or Response input', 'Invalid inputs', 'error')
end

guidata(hObject, handles)

% --- Executes on button press in push_Fit.
function push_Fit_Callback(hObject, ~, handles)
% hObject    handle to push_Fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Temporary variable: Get dose response data for selected groups
subjID      = unique(handles.Data.SubjID); 

% Create results dataset
results = dataset ; 

% Preaallocate 
results.subjID  = subjID ; 
results.EC50    = nan(size(subjID)) ; 
results.Emax    = nan(size(subjID)) ; 

for j = 1:length(handles.groupVars)
    
        if iscell(handles.Data.(handles.groupVars{j})) 
            results.(handles.groupVars{j}) = cell(size(subjID)) ;
        elseif isnumeric(handles.Data.(handles.groupVars{j})) 
            results.(handles.groupVars{j}) = nan(size(subjID)) ;
        end 
            
        
end

model   = cell(1, 2) ;

for i = 1:length(subjID)
    
    ds          = handles.Data(handles.Data.SubjID == subjID(i), :) ;
    
    try 
    model{i, 2} = createFit(ds.(handles.doseVar), ds.(handles.responseVar), [.7, .7, .7]) ;
    model{i, 1} = subjID(i) ;
    
    % compile results
    results.EC50(i)     = model{i, 2}.EC50 ;
    results.Emax(i)     = model{i, 2}.Emax ;  
    
    catch 
            msgbox('Could not fit data. Setting EC50 & Emax to nan for current ID.', 'Fitting Error', 'error', 'replace')
    end
    
    for j = 1:length(handles.groupVars)
        if length(unique(ds.(handles.groupVars{j})) ) == 1
            results.(handles.groupVars{j})(i) = unique(ds.(handles.groupVars{j})) ;
        else
            results.(handles.groupVars{j})(i) = nan ;
            msgbox('Grouping variable must have one unique value per subject. setting value to nan', ...
                'Invalid grouping variable', 'error', 'replace')
        end
            
    end 
end

handles.model   = model ;
handles.results = results; 

% Enable Reset & ANOVA buttons 
set(handles.push_Analyze     , 'Enable', 'on')
set(handles.push_export      , 'Enable', 'on')


% Disable selection button
set(handles.popup_response, 'enable', 'off')
set(handles.popup_dose    , 'enable', 'off')
set(handles.list_groupVars, 'enable', 'off')
set(handles.push_Fit      , 'enable', 'off')

% Update GUIDATA
guidata(hObject, handles)

% --- Executes on button press in push_export.
function push_export_Callback(hObject, eventdata, handles)
% hObject    handle to push_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Select Excel File(s)
[pname, fname] = uiputfile({'*.xlsx; *.xls', 'Excel File (.xls, .xlsx)'}, 'Select Data File') ;

if fname == 0  
   errordlg('Please select data file', 'Load Data Error')
else 
    export(handles.results, 'xlsfile', fullfile(fname, pname));
end 

winopen(fullfile(fname, pname))

% --- Executes on button press in push_Analyze.
function push_Analyze_Callback(hObject, ~, handles)
% hObject    handle to push_Analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

grpStr = cell(1,length(handles.groupVars));
for i = 1:length(handles.groupVars) 
    
    grpStr{i} = handles.results.(handles.groupVars{i}) ;
end 

try
    anovan(handles.results.EC50(:), grpStr, 'varnames', handles.groupVars)
    
catch
    errordlg('Could not perform ANOVA. Check results dataset')
end

guidata(hObject, handles)

% --- Executes on button press in push_reset.
function push_reset_Callback(hObject, ~, handles)
% hObject    handle to push_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear axes
cla ; delete(legend)

% Remove Data 
if isfield(handles, 'results')      , handles = rmfield(handles, 'results')         ; end
if isfield(handles, 'Data')         , handles = rmfield(handles, 'Data')            ; end
if isfield(handles, 'varNames')     , handles = rmfield(handles, 'varNames')        ; end
if isfield(handles, 'grpStr')       , handles = rmfield(handles, 'grpStr')          ; end
if isfield(handles, 'doseVar')      , handles = rmfield(handles, 'doseVar')         ; end
if isfield(handles, 'groupVars')    , handles = rmfield(handles, 'groupVars')       ; end
if isfield(handles, 'fileStr')      , handles = rmfield(handles, 'fileStr')         ; end

if isfield(handles, 'model')      , handles = rmfield(handles, 'model')         ; end
if isfield(handles, 'scatter')    , handles = rmfield(handles, 'scatter')       ; end
if isfield(handles, 'results')    , handles = rmfield(handles, 'results')         ; end

% Empty selects
set(handles.list_groupVars, 'value', 1, 'string', {''}) ;
set(handles.popup_dose, 'value', 1, 'string', {''});
set(handles.popup_response, 'value', 1, 'string', {''}) ;
set(handles.edit_fileString, 'string', {''}) ;

% Enable/Disable buttons
set(handles.push_Fit    , 'enable', 'off'); 
set(handles.push_Analyze, 'enable', 'off'); 
set(handles.push_export, 'enable', 'off'); 
set(handles.push_LoadData   , 'enable', 'on'); 
set(handles.popup_response, 'enable', 'on') ;
set(handles.popup_dose, 'enable', 'on') ;
set(handles.list_groupVars, 'enable', 'on') ;


%% Create functions 
% --- Executes during object creation, after setting all properties.
function axes_plot_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popup_dose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_fileString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fileString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popup_response_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Outputs from this function are returned to the command line.
function varargout = DoseResponseFit_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function list_groupVars_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_groupVars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
