vid = videoinput('winvideo',1);
preview(vid);
set(vid,'ReturnedColorSpace','rgb');
frame = getsnapshot(vid);
%figure;imshow(frame);
writerObj = VideoWriter( ['C:\Users\Administrator\Desktop\new.avi'] );
writerObj.FrameRate = 10;
open(writerObj);
  figure;
  for ii = 1: 200
     frame = getsnapshot(vid);
    %  imshow(frame);
      f.cdata = frame;
     f.colormap = [];
     writeVideo(writerObj,f);
  end
 close(writerObj);