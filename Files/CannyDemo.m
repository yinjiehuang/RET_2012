function varargout = CannyDemo(varargin)
% CANNYDEMO MATLAB code for CannyDemo.fig
%      CANNYDEMO, by itself, creates a new CANNYDEMO or raises the existing
%      singleton*.
%
%      H = CANNYDEMO returns the handle to a new CANNYDEMO or the handle to
%      the existing singleton*.
%
%      CANNYDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CANNYDEMO.M with the given input arguments.
%
%      CANNYDEMO('Property','Value',...) creates a new CANNYDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CannyDemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CannyDemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CannyDemo

% Last Modified by GUIDE v2.5 10-Jul-2012 21:57:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CannyDemo_OpeningFcn, ...
                   'gui_OutputFcn',  @CannyDemo_OutputFcn, ...
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

% --- Executes just before CannyDemo is made visible.
function CannyDemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CannyDemo (see VARARGIN)

% Choose default command line output for CannyDemo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using CannyDemo.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes CannyDemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CannyDemo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename ,pathname]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.gif'},'Choose Image');
if filename==0
    return;
else
    str=[pathname filename];
    Im=imread(str);
    global Image;
    Image=Im;
    axes(handles.axes1);
    cla;
    imshow(Image);
end


% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Image;
%Now let's do the Gaussian Filter
[H,W,C]=size(Image);
if C~=1
    GImage=rgb2gray(Image);
else
    GImage=Image;
end
GImage=double(GImage);
Sigma=str2double(get(handles.edit4,'String'));
Sz=str2double(get(handles.edit3,'String'));
GaMask=Gaussian(Sigma,Sz);
GaIm=conv2(GImage,GaMask,'same');
global GaImage;
GaImage=GaIm;
axes(handles.axes2);
cla;
imshow(GaIm,[]);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GaImage;
SobelX=[-1,0,1;-2,0,2;-1,0,1];
SobelY=[1 2 1;0 0 0;-1 -2 -1];
GradientX=conv2(GaImage,SobelX,'same');
GradientY=conv2(GaImage,SobelY,'same');
EdgeStre=sqrt((GradientX).^2+(GradientY).^2);
EdgeDire=atan((GradientY)./(GradientX))*180/pi;
global EMImage;
EMImage=EdgeStre;
global EAImage;
EAImage=EdgeDire;
axes(handles.axes3);
cla;
imshow(EMImage,[]);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EMImage;
EdgeStre=EMImage;
global EAImage;
EdgeDire=EAImage;
[H,W,C]=size(EdgeDire);
for x=1:H
    for y=1:W
        %First of all, devide the direction in to 4-connected neighbourhood
        if (EdgeDire(x,y)>=-90 && EdgeDire(x,y)<-67.5) || (EdgeDire(x,y)>=67.5 && EdgeDire(x,y)<=90)
            EdgeDire(x,y)=90;
            Neigh1=EdgeStre(max(x-1,1),y);
            Neigh2=EdgeStre(min(x+1,H),y);
        elseif EdgeDire(x,y)>=-67.5 && EdgeDire(x,y)<-22.5
            EdgeDire(x,y)=-45;
            Neigh1=EdgeStre(max(x-1,1),max(y-1,1));
            Neigh2=EdgeStre(min(x+1,H),min(y+1,W));
        elseif EdgeDire(x,y)>=-22.5 && EdgeDire(x,y)<22.5
            EdgeDire(x,y)=0;
            Neigh1=EdgeStre(x,max(y-1,1));
            Neigh2=EdgeStre(x,min(y+1,W));
        elseif EdgeDire(x,y)>=22.5 && EdgeDire(x,y)<67.5
            EdgeDire(x,y)=45;
            Neigh1=EdgeStre(max(x-1,1),min(y+1,W));
            Neigh2=EdgeStre(min(x+1,H),max(y-1,1));
        end
        %After we know the direction, we compare the neighbour value
        if EdgeStre(x,y)<Neigh1 || EdgeStre(x,y)<Neigh2
            EdgeStre(x,y)=0;
        end
    end
end
%Crop off the image size edge
EdgeStre(1,:)=0;
EdgeStre(:,1)=0;
EdgeStre(H,:)=0;
EdgeStre(:,W)=0;

global NonMImage;
NonMImage=EdgeStre;
axes(handles.axes4);
cla;
imshow(EdgeStre,[]);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NonMImage;
EdgeStre=NonMImage;

[H,W,C]=size(EdgeStre);
High_T=str2double(get(handles.edit1,'String'));
Low_T=str2double(get(handles.edit2,'String'));
EdgeStre=EdgeStre/max(max(EdgeStre));
Indicator=ones(H,W);
%The pixel value which is larger than high threshold is marked as strong edge
temp=find(EdgeStre>=High_T);
Indicator(temp)=2;%We use 2 to indicate strong edge
EdgeStre(temp)=1;
%The pixel value which is smaller than low threshold is marked as background
temp=find(EdgeStre<=Low_T);
Indicator(temp)=0;%We use 0 to supress the 
EdgeStre(temp)=0;
global DTImage;
DTImage=EdgeStre;
global Indi;
Indi=Indicator;
axes(handles.axes5);
cla;
imshow(EdgeStre,[]);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DTImage;
EdgeStre=DTImage;
[H,W,C]=size(EdgeStre);
global Indi;
Indicator=Indi;
flagg=1;
while (flagg)
    flagg=0;
    %Find the weak edges and get the poitions
    [InX,InY]=find(Indicator==1);
    for i=1:length(InX)
        %Find eight neighbours of the weak pixel
        N1=[max(InX(i)-1,1),max(InY(i)-1,1)];
        N2=[max(InX(i)-1,1),InY(i)];
        N3=[max(InX(i)-1,1),min(InY(i)+1,W)];
        N4=[InX(i),max(InY(i)-1,1)];
        N5=[InX(i),min(InY(i)+1,W)];
        N6=[min(InX(i)+1,H),max(InY(i)-1,1)];
        N7=[min(InX(i)+1,H),InY(i)];
        N8=[min(InX(i)+1,H),min(InY(i)+1,W)];
        if Indicator(N1(1),N1(2))==2 || Indicator(N2(1),N2(2))==2 || Indicator(N3(1),N3(2))==2 ...
            || Indicator(N4(1),N4(2))==2 || Indicator(N5(1),N5(2))==2 || Indicator(N6(1),N6(2))==2 ...
            || Indicator(N7(1),N7(2))==2 || Indicator(N8(1),N8(2))==2
            %If the neighbours do exist strong edges
            EdgeStre(InX(i),InY(i))=1;
            Indicator(InX(i),InY(i))=2;
            flagg=1;
        end
    end
end
EdgeStre(find(Indicator==1))=0;
global result;
result=EdgeStre;
axes(handles.axes6);
cla;
imshow(EdgeStre,[]);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Image;
%Now let's do the Gaussian Filter
[H,W,C]=size(Image);
if C~=1
    GImage=rgb2gray(Image);
else
    GImage=Image;
end
GImage=double(GImage);
Sigma=str2double(get(handles.edit4,'String'));
Sz=str2double(get(handles.edit3,'String'));
GaMask=Gaussian(Sigma,Sz);
GaIm=conv2(GImage,GaMask,'same');
axes(handles.axes2);
imshow(GaIm,[]);

SobelX=[-1,0,1;-2,0,2;-1,0,1];
SobelY=[1 2 1;0 0 0;-1 -2 -1];
GradientX=conv2(GaIm,SobelX,'same');
GradientY=conv2(GaIm,SobelY,'same');
EdgeStre=sqrt((GradientX).^2+(GradientY).^2);
EdgeDire=atan((GradientY)./(GradientX))*180/pi;
axes(handles.axes3);
imshow(EdgeStre,[]);

for x=1:H
    for y=1:W
        %First of all, devide the direction in to 4-connected neighbourhood
        if (EdgeDire(x,y)>=-90 && EdgeDire(x,y)<-67.5) || (EdgeDire(x,y)>=67.5 && EdgeDire(x,y)<=90)
            EdgeDire(x,y)=90;
            Neigh1=EdgeStre(max(x-1,1),y);
            Neigh2=EdgeStre(min(x+1,H),y);
        elseif EdgeDire(x,y)>=-67.5 && EdgeDire(x,y)<-22.5
            EdgeDire(x,y)=-45;
            Neigh1=EdgeStre(max(x-1,1),max(y-1,1));
            Neigh2=EdgeStre(min(x+1,H),min(y+1,W));
        elseif EdgeDire(x,y)>=-22.5 && EdgeDire(x,y)<22.5
            EdgeDire(x,y)=0;
            Neigh1=EdgeStre(x,max(y-1,1));
            Neigh2=EdgeStre(x,min(y+1,W));
        elseif EdgeDire(x,y)>=22.5 && EdgeDire(x,y)<67.5
            EdgeDire(x,y)=45;
            Neigh1=EdgeStre(max(x-1,1),min(y+1,W));
            Neigh2=EdgeStre(min(x+1,H),max(y-1,1));
        end
        %After we know the direction, we compare the neighbour value
        if EdgeStre(x,y)<Neigh1 || EdgeStre(x,y)<Neigh2
            EdgeStre(x,y)=0;
        end
    end
end
%Crop off the image size edge
EdgeStre(1,:)=0;
EdgeStre(:,1)=0;
EdgeStre(H,:)=0;
EdgeStre(:,W)=0;

axes(handles.axes4);
imshow(EdgeStre,[]);

High_T=str2double(get(handles.edit1,'String'));
Low_T=str2double(get(handles.edit2,'String'));
EdgeStre=EdgeStre/max(max(EdgeStre));
Indicator=ones(H,W);
%The pixel value which is larger than high threshold is marked as strong edge
temp=find(EdgeStre>=High_T);
Indicator(temp)=2;%We use 2 to indicate strong edge
EdgeStre(temp)=1;
%The pixel value which is smaller than low threshold is marked as background
temp=find(EdgeStre<=Low_T);
Indicator(temp)=0;%We use 0 to supress the 
EdgeStre(temp)=0;

axes(handles.axes5);
imshow(EdgeStre,[]);

flagg=1;
while (flagg)
    flagg=0;
    %Find the weak edges and get the poitions
    [InX,InY]=find(Indicator==1);
    for i=1:length(InX)
        %Find eight neighbours of the weak pixel
        N1=[max(InX(i)-1,1),max(InY(i)-1,1)];
        N2=[max(InX(i)-1,1),InY(i)];
        N3=[max(InX(i)-1,1),min(InY(i)+1,W)];
        N4=[InX(i),max(InY(i)-1,1)];
        N5=[InX(i),min(InY(i)+1,W)];
        N6=[min(InX(i)+1,H),max(InY(i)-1,1)];
        N7=[min(InX(i)+1,H),InY(i)];
        N8=[min(InX(i)+1,H),min(InY(i)+1,W)];
        if Indicator(N1(1),N1(2))==2 || Indicator(N2(1),N2(2))==2 || Indicator(N3(1),N3(2))==2 ...
            || Indicator(N4(1),N4(2))==2 || Indicator(N5(1),N5(2))==2 || Indicator(N6(1),N6(2))==2 ...
            || Indicator(N7(1),N7(2))==2 || Indicator(N8(1),N8(2))==2
            %If the neighbours do exist strong edges
            EdgeStre(InX(i),InY(i))=1;
            Indicator(InX(i),InY(i))=2;
            flagg=1;
        end
    end
end
EdgeStre(find(Indicator==1))=0;
global result;
result=EdgeStre;
axes(handles.axes6);
imshow(EdgeStre,[]);


% --------------------------------------------------------------------
function HelpMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to HelpMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'This Demo is developed by Yinjie Huang from University of Central Florida Machine Learning Lab.';'';...
    'This Demo is used to show Canny Edge Detector.';'';...
    'First Open an image and set the High and Low Threshold (between 0 and 1), input the size (odd number such as 1, 3, 5,...) and sigma value (positive number) of the Gaussian filter.';'';...
    'Click Run Canny By One Click and you could get all the results.';'';...
    'You could also click the different buttons to see the five steps of the Canny Edge Detector.'});


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile({'*.jpg','JPEG(*.jpg)';...
                                 '*.bmp','Bitmap(*.bmp)';...
                                 '*.gif','GIF(*.gif)';...
                                 '*.*',  'All Files (*.*)'},...
                                 'Save Picture','Untitled');
if FileName==0
    return;
else
    h=getframe(handles.axes6);
    imwrite(h.cdata,[PathName,FileName]);
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Image;
[H,W,C]=size(Image);
if C==1
    Im=zeros(H,W,3);
    Im(:,:,1)=Image;
    Im(:,:,2)=Image;
    Im(:,:,3)=Image;
    Im=uint8(Im);
else
    Im=Image;
end
open('result.fig')
h = guihandles;  
axes(h.axes1);
imshow(Im);
global result;
Final=Im;
[IndexX,IndexY]=find(result==1);
n=length(IndexX);
for i=1:n
    Final(IndexX(i),IndexY(i),1)=255; 
    Final(IndexX(i),IndexY(i),2)=0;
    Final(IndexX(i),IndexY(i),3)=0;
end
axes(h.axes2);
imshow(Final);
