% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Left Eyebrow    = 1 - 5
% % Right Eyebrow   = 6 - 10
% % Left Eyes       = 20 - 25
% % Right Eyes      = 26 - 31
% % Nose            = 11 - 19
% % mouth           = 32 - 49
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear; close all; clc;
addpath(genpath('.'));

% % Load Models
fitting_model='models/Chehra_f1.0.mat';
load(fitting_model);    

FD      = vision.CascadeObjectDetector();
catTipe = {'AlisKiri' 'AlisKanan' 'MataKiri' 'MataKanan' 'Mulut' 'Dahi' 'All'};
locFig  = {'northwest' 'north' 'northeast' 'southwest' 'south' 'southeast'};

% % INPUT USER

% catTipe{1} = AlisKiri
% catTipe{2} = AlisKanan
% catTipe{3} = MataKiri
% catTipe{4} = MataKanan
% catTipe{5} = Mulut
% catTipe{6} = Dahi
% catTipe{7} = All
tipeFeat   = catTipe{2}; % type feature

label      = 'Happiness'; % label for dataset
%nmFold    = 'disgust/25_EP09_02';
nmFold     = 'EP02_01f'; % folder location
is_show    = 'on'; % set figure on or off

% % EOF INPUT USER

nFold      = ['test_images/sequence/' nmFold '/'];
imFol      = dir(fullfile(nFold,'*.jpg'));
imFol      = natsortfiles({imFol.name});
nmFoldRes  = ['results/sequence/' nmFold];
sMax       = size(imFol,2);

disp('Get Data.........');

if(sMax > 0)
    for frame = 1:numel(imFol)-1
        % % name file
        nameFile1 = [nFold imFol{frame}];
        nameFile2 = [nFold imFol{frame+1}];
%         nameFile2 = [nFold imFol{1}];
 
        % % Load Image
        img0 = imread(nameFile1);
        img1 = imread(nameFile2);
        
     
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
        
%         if frame == 1
             points = Fitting(input0,init0,RegMat,MaxIter);
%         else
%              points = [points(:,1), points(:,2)];
%         end

        [imgFeature0,bboxFeat0] = getFeaturesFace(points,input0,tipeFeat);
        [imgFeature1,bboxFeat1] = getFeaturesFace(points,input1,tipeFeat);
% %          if(frame == 2)
             figure(1), imshow(img0),  title(sprintf('Frame %d',frame));
             hold on;
             plot(points(:,1),points(:,2),'g*','MarkerSize',6);  
% 
             rectangle('Position',bboxFeat1{1},'EdgeColor','r')  
%               text(bboxFeat1{1}(1) ,bboxFeat1{1}(2) ,'1', 'FontSize', 20, 'Color', 'white')
             rectangle('Position',bboxFeat1{2},'EdgeColor','r')
%               text(bboxFeat1{2}(1) ,bboxFeat1{2}(2) ,'2', 'FontSize', 20, 'Color', 'white')
             rectangle('Position',bboxFeat1{3},'EdgeColor','r')
%               text(bboxFeat1{3}(1) ,bboxFeat1{3}(2) ,'3', 'FontSize', 20, 'Color', 'white')
             rectangle('Position',bboxFeat1{4},'EdgeColor','r')
%               text(bboxFeat1{4}(1) ,bboxFeat1{4}(2) ,'4', 'FontSize', 20, 'Color', 'white')
             rectangle('Position',bboxFeat1{5},'EdgeColor','r')
%               text(bboxFeat1{5}(1) ,bboxFeat1{5}(2) ,'5', 'FontSize', 20, 'Color', 'white')
             rectangle('Position',bboxFeat1{6},'EdgeColor','r')
%              text(bboxFeat1{6}(1) ,bboxFeat1{6}(2) ,'6', 'FontSize', 20, 'Color', 'white')
          hold off;
          disp([num2str(bboxFeat1{1}) '|' num2str(bboxFeat1{2}) '|' num2str(bboxFeat1{3}) '|' num2str(bboxFeat1{4}) '|' num2str(bboxFeat1{5}) '|' num2str(bboxFeat1{6})]);
          saveas(gcf,['results/sequence/happiness/dinamis/' num2str(frame) '.png'])
%          end         
 
    end
else
    disp('Folder Tidak Ditemukan');
end

