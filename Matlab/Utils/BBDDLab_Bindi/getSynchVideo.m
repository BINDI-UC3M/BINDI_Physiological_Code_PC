windowProc  = 20;
overlapProc = 2;
volunteer   = 1;
stimulus    = 1;
feats       = data_features_v003_1to2;

%%
v = VideoReader('Mammamia.mp4');
v.CurrentTime = windowProc; %Time to begin
frameratevideo=v.FrameRate;
nFrames = v.Duration*v.FrameRate; % Number of frames
%v.CurrentTime = 0.0;
 
x = windowProc:overlapProc:length(...
    feats{volunteer,stimulus}.EH.Video.BVP_feats(:,21))*...
                                                  overlapProc+windowProc-1;
hrv  = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,3);   
lfhf = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,11);   
csi  = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,21);
cvi  = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,23);
 
myVideo = VideoWriter('v003_v1_sympara'); %open video file
myVideo.FrameRate = 2;  %same as the input video
open(myVideo);
 
figure('WindowState','maximized','Color',[1 1 1]);
%set(gcf,'Position',[100 100 800 400]);
sub1=subplot(3,2,[1 3 5]);

xy2=subplot(3,2,6);
% Create ylabel
ylabel('CSI and CVI index');
% Create xlabel
xlabel('Time');
set(xy2,'FontName','Times New Roman','FontSize',18);

h2=animatedline('marker','o');
h3=animatedline('marker','+');

xy3=subplot(3,2,2);
% Create ylabel
ylabel('HRV_{rmssd}');
% Create xlabel
xlabel('Time');
set(xy3,'FontName','Times New Roman','FontSize',18);

h4=animatedline('marker','^');

xy4=subplot(3,2,4);
% Create ylabel
ylabel('LF/HF');
% Create xlabel
xlabel('Time');
set(xy4,'FontName','Times New Roman','FontSize',18);

h5=animatedline('marker','>');
 
i=0;
%%% Animate
while hasFrame(v)
    
    pause(1/v.FrameRate);
    
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', sub1);
    sub1.Visible = 'off';
    
    i = i + 1;
    
    legend(xy2,'csi','cvi')
    addpoints(h2,x(i),csi(i));
    drawnow
    addpoints(h3,x(i),cvi(i));
    drawnow
    
    legend(xy3,'hrv_{rmssd}')
    addpoints(h4,x(i),hrv(i));
    drawnow
    
    legend(xy4,'LF/HF')
    addpoints(h5,x(i),lfhf(i));
    drawnow
    
    pause(1/v.FrameRate);
 
    frame=getframe(gcf);
    writeVideo(myVideo, frame);
   % set(h,'YData',y(1:index(i)), 'XData', t(1:index(i)))
   
   if floor(v.Duration)>v.CurrentTime + 2
    v.CurrentTime = v.CurrentTime + 2; %Time to begin
   else
    v.CurrentTime = v.Duration;
   end
    
end

close(myVideo);
close all;

%%

stimulus = 2;

v = VideoReader('TheForest.mp4');
v.CurrentTime = windowProc; %Time to begin
frameratevideo=v.FrameRate;
nFrames = v.Duration*v.FrameRate; % Number of frames
%v.CurrentTime = 0.0;
 
x = windowProc:overlapProc:length(...
    feats{volunteer,stimulus}.EH.Video.BVP_feats(:,21))*...
                                                  overlapProc+windowProc-1;
hrv  = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,3);   
lfhf = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,11);   
csi  = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,21);
cvi  = feats{volunteer,stimulus}.EH.Video.BVP_feats(:,23);
 
myVideo = VideoWriter('v003_v2_sympara'); %open video file
myVideo.FrameRate = 2;  %same as the input video
open(myVideo);
 
figure('WindowState','maximized','Color',[1 1 1]);
%set(gcf,'Position',[100 100 800 400]);
sub1=subplot(3,2,[1 3 5]);

xy2=subplot(3,2,6);
% Create ylabel
ylabel('CSI and CVI index');
% Create xlabel
xlabel('Time');
set(xy2,'FontName','Times New Roman','FontSize',18);

h2=animatedline('marker','o');
h3=animatedline('marker','+');

xy3=subplot(3,2,2);
% Create ylabel
ylabel('HRV_{rmssd}');
% Create xlabel
xlabel('Time');
set(xy3,'FontName','Times New Roman','FontSize',18);

h4=animatedline('marker','^');

xy4=subplot(3,2,4);
% Create ylabel
ylabel('LF/HF');
% Create xlabel
xlabel('Time');
set(xy4,'FontName','Times New Roman','FontSize',18);

h5=animatedline('marker','>');
 
i=0;
%%% Animate
while hasFrame(v)
    
    pause(1/v.FrameRate);
    
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', sub1);
    sub1.Visible = 'off';
    
    i = i + 1;
    
    legend(xy2,'csi','cvi')
    addpoints(h2,x(i),csi(i));
    drawnow
    addpoints(h3,x(i),cvi(i));
    drawnow
    
    legend(xy3,'hrv_{rmssd}')
    addpoints(h4,x(i),hrv(i));
    drawnow
    
    legend(xy4,'LF/HF')
    addpoints(h5,x(i),lfhf(i));
    drawnow
    
    pause(1/v.FrameRate);
 
    frame=getframe(gcf);
    writeVideo(myVideo, frame);
   % set(h,'YData',y(1:index(i)), 'XData', t(1:index(i)))
   
   if floor(v.Duration)>v.CurrentTime + 2 && (i+1)<length(csi)
    v.CurrentTime = v.CurrentTime + 2; %Time to begin
   else
    v.CurrentTime = v.Duration;
   end
    
end

close(myVideo);