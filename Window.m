function varargout = Window(varargin)
% WINDOW MATLAB code for Window.fig
%      WINDOW, by itself, creates a new WINDOW or raises the existing
%      singleton*.
%
%      H = WINDOW returns the handle to a new WINDOW or the handle to
%      the existing singleton*.
%
%      WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WINDOW.M with the given input arguments.
%
%      WINDOW('Property','Value',...) creates a new WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Window

% Last Modified by GUIDE v2.5 27-Jun-2019 16:30:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Window_OpeningFcn, ...
                   'gui_OutputFcn',  @Window_OutputFcn, ...
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
end

% --- Executes just before Window is made visible.
function Window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Window (see VARARGIN)

% Choose default command line output for Window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Window wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes during object creation, after setting all properties.
function axeslive_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axeslive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axeslive
% fileName = 'C:\Users\Administrator\Desktop\new.avi';  
% obj = VideoReader(fileName); 
% numFrames = obj.NumberOfFrames;                     % 读取视频的帧数  
% for i = 1 : numFrames      
%     frame = read(obj,i);                            % 读取每一帧    
%     figure
%     imshow(frame)                                %显示每一帧      
%end
end


% --- Executes on mouse press over axes background.
function axeslive_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axeslive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename,pathname]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.*'},'载入图像');
%    if isequal(filename,0)|isequal(pathname,0)
%       errordlg('没有选中文件','出错');
%    return;
%    else 
%    file=[pathname,filename];
%    end
% pic = imread(file);
% axes(handles.axeslive);
% imshow(pic);
% title(date,'color','r');
end



% --- Executes on button press in pushbuttonshow.
function pushbuttonshow_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.*'},'载入图像');
   if isequal(filename,0)|isequal(pathname,0)
      errordlg('没有选中文件','出错');
   return;
   else 
   file=[pathname,filename];
   end
pic = imread(file);
axes(handles.axeslive);
imshow(pic);
title(date,'color','r');
end


% --- Executes on button press in pushbuttoncam.
function pushbuttoncam_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttoncam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = videoinput('winvideo',1);
preview(vid);
set(vid,'ReturnedColorSpace','rgb');
frame = getsnapshot(vid);
writerObj = VideoWriter( ['C:\Users\Administrator\Desktop\new.avi'] );
writerObj.FrameRate = 10;
open(writerObj);
  figure;
   for ii = 1: 100
      frame = getsnapshot(vid);
     %  imshow(frame);
       f.cdata = frame;
      f.colormap = [];
      writeVideo(writerObj,f);
   end
 close(writerObj);
   end



% --- Executes during object deletion, before destroying properties.
function pushbuttoncam_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttoncam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in pushbuttondetect.
function pushbuttondetect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttondetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% fileName = 'C:\Users\Administrator\Desktop\new.avi';  
% obj = VideoReader(fileName); 
% numFrames = obj.NumberOfFrames;                     % 读取视频的帧数  
% for i = 1 : numFrames       
%     frame = read(obj,i);                            % 读取每一帧    
%     figure
%     axes(handles.axesdetect);
%     imshow(frame)                                %显示每一帧    
%      title(date,'color','r');
% end
load C:\Users\Administrator\detectorcar detector 
global num
while(1)
videoname=['F:\VideoDivided_image\',num2str(num-1),'.avi']
v = VideoReader(videoname); 
%  numFrames = v.NumberOfFrames%帧的总数
%  videoF=v.FrameRate%视频采集速率
%  videoD=v.Duration
%  numname=6;%the length of image name
%  nz = strcat('%0',num2str(numname),'d');
%  T=1*videoF%%提取帧数间隔
%  i=1
%  for k = 1 :T: numFrames 
%      numframe = read(v,k)
%      axes(handles.axesdetect);
%      imshow(numframe)
     %numframe = read(v,k)%读取第几帧
%     num=sprintf(nz,i);   %i为保存图片的序号
%      i=i+1;
%    imwrite(numframe,strcat('F:\VideoDivided_image\001\',num,'.png'),'png'); 
 %end
%一次读取一帧, 直至视频结尾
 %k=50;
%vi = VideoReader('F:\download\datavideo\bdd100k_videos_test_00\cabc30fc-e7726578.mov');
  %LEN=vi.NumberOfFrames;
 while hasFrame(v)
      f = readFrame(v);   
  [bbox, score, label] = detect(detector, f);
     detectedImg = insertShape(f, 'Rectangle', bbox);
     axes(handles.axesdetect);
     imshow(f)
%     % k = k+1;
 end
end
end


% --- Executes on button press in pushbuttonclear.
function pushbuttonclear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
clear all;
close(gcf);
end


% --- Executes on button press in pushbuttonclassify.
function pushbuttonclassify_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonclassify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('C:\Users\Administrator\matlab\trainedNet5.mat')
load('C:\Users\Administrator\matlab\testDS5.mat')
% videoReader = vision.VideoFileReader('F:\download\datavideo\bdd100k_videos_test_00\cabe1040-5f02711e.mov');
 videoPlayer = vision.DeployableVideoPlayer;
 position = [35 185];
 position2 = [35 600];

vid = videoinput('winvideo',1);
preview(vid);
set(vid,'ReturnedColorSpace','rgb');
frame = getsnapshot(vid);

writerObj = VideoWriter( ['F:\matlab\carcamvideo\1.avi'] );
writerObj.FrameRate = 10;
open(writerObj);
  figure;
   for ii = 1: 200
      frame = getsnapshot(vid);
       f.cdata = frame;
     f.colormap = [];
     im = im2uint8(imresize(frame, [227 227],'bilinear')) ;
   % im=imcrop(frame,[440 100 200 1080]);
    %im = im2uint8(imresize(im ,[227 227]));
    [YPred,probs] = classify(net,im);
     RGB = insertText(im,position,char(YPred),'FontSize',18,'TextColor','white','BoxColor','black');
    RGB = insertText(RGB,position2,sprintf('%.2f',round(max(probs),2)),'FontSize',18,'TextColor','white','BoxColor','green');
    step(videoPlayer,RGB);   
      writeVideo(writerObj,im);
      ii;
   end
 close(writerObj);
end
