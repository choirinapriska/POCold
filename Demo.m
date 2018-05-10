% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Left Eyebrow    = 1 - 5
% % Right Eyebrow   = 6 - 10
% % Left Eyes       = 20 - 25
% % Right Eyes      = 26 - 31
% % Nose            = 11 - 19
% % mouth           = 32 - 49
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%% This warning is displayed when your requested worksheet does not exist and is created
warning('off','MATLAB:xlswrite:AddSheet');

clear; close all; clc;
addpath(genpath('.'));

% % Load Models
fitting_model='models/Chehra_f1.0.mat';
load(fitting_model);    

%% Init FaceDetection
FD      = vision.CascadeObjectDetector();

%% Init Video
nFile   = 'VID-20170425-WA0010.mp4';
video   = VideoReader(sprintf('test_images/%s',nFile));
fMax    = floor(video.FrameRate*video.Duration);

% See getFeatures.m
% Tipe Feature : AlisKiri, AlisKanan, MataKanan, MataKiri, Mulut 
tipeFeat   = 'All';
nmFoldRes  = ['results/' nFile];

out_AlisKiri  = cell(1,fMax);
out_AlisKanan = cell(1,fMax);
out_MataKiri  = cell(1,fMax);
out_MataKanan = cell(1,fMax);
out_Mulut     = cell(1,fMax);
out_Dahi      = cell(1,fMax);
output        = cell(1,fMax);

%% Create Folder 
% mkdir(nmFoldRes);

frame = 1;
% Perform Fitting
while(frame < fMax)
    % % Load Image
    img0 = read(video,frame);
    img1 = read(video,frame+1);

%     figure, imshow(img0); title(['Frame : ' num2str(frame)]);
%     figure, imshow(img1); title(['Frame : ' num2str(frame+1)]);
    
     if frame == 1
         bbox = step(FD, img0);
     else
         bbox = [bbox(1),bbox(2),bbox(3),bbox(4)];
     end
         
      img0  = imcrop(img0, bbox);
      img1  = imcrop(img1, bbox);
    
    [input0, init0] = getLandmark(img0,refShape,[0,0,bbox(3),bbox(4)]);
    [input1, init1] = getLandmark(img1,refShape,[0,0,bbox(3),bbox(4)]);
         
    MaxIter=6;
     if frame < 2
         points = Fitting(input0,init0,RegMat,MaxIter);
     else
         points = [points(:,1), points(:,2)];
     end
                   
     [imgFeature0,bboxFeat0] = getFeaturesFace(points,input0,tipeFeat);
     [imgFeature1,bboxFeat1] = getFeaturesFace(points,input1,tipeFeat);
     
     figure(1), imshow(img0),  title(sprintf('Frame %d',frame));hold on;
     plot(points(:,1),points(:,2),'g*','MarkerSize',6);     
     rectangle('Position',bboxFeat0{1},'EdgeColor','r')
     rectangle('Position',bboxFeat0{2},'EdgeColor','r')
     rectangle('Position',bboxFeat0{3},'EdgeColor','r')
     rectangle('Position',bboxFeat0{4},'EdgeColor','r')
     rectangle('Position',bboxFeat0{5},'EdgeColor','r')
     rectangle('Position',bboxFeat0{6},'EdgeColor','r')
     
     hold off;

%     hold on;
%     figure(frame),
%     if(strcmp('All',tipeFeat))
% 
%         [poc{1}, out_AlisKiri{frame},qv_AlisKiri]       = getPOC(imgFeature0{1,1}, imgFeature1{1,1},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'AlisKiri'), 'EyeBrowLeft');
%         [poc{2}, out_AlisKanan{frame},qv_AlisKanan]     = getPOC(imgFeature0{1,2}, imgFeature1{1,2},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'AlisKanan'), 'EyeBrowRight');
%         [poc{3}, out_MataKiri{frame},qv_MataKiri]       = getPOC(imgFeature0{1,3}, imgFeature1{1,3},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'MataKiri'), 'EyeLeft');
%         [poc{4}, out_MataKanan{frame},qv_MataKanan]     = getPOC(imgFeature0{1,4}, imgFeature1{1,4},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'MataKanan'),'EyeRight');
%         [poc{5}, out_Mulut{frame},qv_Mulut]             = getPOC(imgFeature0{1,5}, imgFeature1{1,5},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'Mulut'),'Mouth');
%         [poc{6}, out_Dahi{frame},qv_Dahi]               = getPOC(imgFeature0{1,6}, imgFeature1{1,6},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'Forehead'),'Forehead');
%         
%         quiv(frame,:) = [frame,qv_AlisKiri,qv_AlisKanan,qv_MataKiri,qv_MataKanan,qv_Mulut,qv_Dahi];
%         var_quiv      = {'Frame';'AlisKiri'; 'AlisKanan';'MataKiri';'MataKanan';'Mulut';'Dahi'};
%     else
%         [poc,output{frame},qv]  = getPOC(imgFeature0, imgFeature1,frame, sprintf('%s/%s',nmFoldRes,tipeFeat), tipeFeat);
%         
%         quiv(frame,:) = [frame,qv];
%         var_quiv      = {'Frame';tipeFeat};
%     end

%     hold off;
    
    pause(0.001);
    frame = frame + 1;
end

% quivAll =array2table(quiv,'VariableNames',var_quiv);

% disp(quivAll);
