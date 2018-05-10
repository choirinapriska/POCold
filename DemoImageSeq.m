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

% % Test Path
nmFold    = 'lala';
nFold   = ['test_images/sequence/' nmFold '/'];
imFol   = dir([nFold, '*jpg']);

% See getFeatures.m
% Tipe Feature : AlisKiri, AlisKanan, MataKanan, MataKiri, Mulut,All 
tipeFeat   = 'AlisKanan';
nmFoldRes  = ['results/sequence/' nmFold];
sMax       = size(imFol,1);

% mkdir(nmFoldRes);

frame = 1;

disp('Get Data.........');

if(sMax > 0)
    while frame <= sMax
        % % Load Image
        img0 = imread([nFold,imFol(frame).name]);
%         img1 = imread([nFold,imFol(frame+1).name]);
        
        
    %     figure, imshow(img0); title(['Frame : ' num2str(frame)]);
    %     figure, imshow(img1); title(['Frame : ' num2str(frame+1)]);

%          if frame == 1
             bbox = step(FD, img0);
%          else
%              bbox = [bbox(1),bbox(2),bbox(3),bbox(4)];
%          end
        
%         figure, imshow(imcrop(img0, bbox)),  title(sprintf('Frame %d',frame));hold on;
%         rectangle('Position',bbox,'EdgeColor','r') 
%         hold off;
        
%          saveas(gcf,['results/lala/img' imFol(frame).name '.png'])
%         return;
        
         img0  = imcrop(img0, bbox);
%          img1  = imcrop(img1, bbox);
% 
        [input0, init0] = getLandmark(img0,refShape,[0,0,bbox(3),bbox(4)]);
%         [input1, init1] = getLandmark(img1,refShape,[0,0,bbox(3),bbox(4)]);
% 
        MaxIter=6;
         if frame < 2
             points = Fitting(input0,init0,RegMat,MaxIter);
         else
             points = [points(:,1), points(:,2)];
         end
% 
         [imgFeature0,bboxFeat0] = getFeaturesFace(points,input0,tipeFeat);
%          [imgFeature1,bboxFeat1] = getFeaturesFace(points,input1,tipeFeat);
%           
% %          disp(['Frame : ' num2str(frame) ' | H : ' num2str(size(imgFeature0,1)) ' | W: ' num2str(size(imgFeature0,2))]);
% %          disp(['Frame : ' num2str(frame) ' | H : ' num2str(size(imgFeature1,1)) ' | W: ' num2str(size(imgFeature1,2))]);
%          
%          %% Aktifkan ini jika ingin menampilkan wajah dengan landmark dan rectangle nya
%          figure, imshow(img0),  title(sprintf('Frame %d',frame));hold on;
%          plot(points(:,1),points(:,2),'g*','MarkerSize',6); % Ini
%          
%          
%          rectangle('Position',bboxFeat0{1},'EdgeColor','r') 
%          rectangle('Position',bboxFeat0{2},'EdgeColor','r')
%          rectangle('Position',bboxFeat0{3},'EdgeColor','r')
%          rectangle('Position',bboxFeat0{4},'EdgeColor','r')
%          rectangle('Position',bboxFeat0{5},'EdgeColor','r')
%          rectangle('Position',bboxFeat0{6},'EdgeColor','r')
%          hold off;

        f_AlisKiri =bboxFeat0{1};
        f_AlisKanan =bboxFeat0{2};
        f_MataKiri =bboxFeat0{3};
        f_MataKanan =bboxFeat0{4};
        f_Mulut =bboxFeat0{5};
        f_Dahi =bboxFeat0{6};
         
         mkdir(['results/komponen/' imFol(frame).name ]);
        imwrite(imcrop(img0,f_AlisKiri),['results/komponen/' imFol(frame).name '/AlisKiri.png'])
        imwrite(imcrop(img0,f_AlisKanan),['results/komponen/' imFol(frame).name '/AlisKanan.png'])
        imwrite(imcrop(img0,f_MataKiri),['results/komponen/' imFol(frame).name '/MataKiri.png'])
        imwrite(imcrop(img0,f_MataKanan),['results/komponen/' imFol(frame).name '/MataKanan.png'])
        imwrite(imcrop(img0,f_Mulut),['results/komponen/' imFol(frame).name '/Mulut.png'])
        imwrite(imcrop(img0,f_Dahi),['results/komponen/' imFol(frame).name '/Dahi.png'])
         
%          %% EOF 
% 
% 
%     %     hold on;
%     %     figure(frame),
%         head{1} = 'Frame';
%         if(strcmp('All',tipeFeat))
%             disp('d');
%             [poc{1}, out_EBL{frame}]    = getPOC(imgFeature0{1,1}, imgFeature1{1,1},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'AlisKiri'), 'EyeBrowLeft');
%             [poc{2}, out_EBR{frame}]    = getPOC(imgFeature0{1,2}, imgFeature1{1,2},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'AlisKanan'), 'EyeBrowRight');
%             [poc{3}, out_EL{frame}]     = getPOC(imgFeature0{1,3}, imgFeature1{1,3},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'MataKiri'), 'EyeLeft');
%             [poc{4}, out_ER{frame}]     = getPOC(imgFeature0{1,4}, imgFeature1{1,4},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'MataKanan'),'EyeRight');
%             [poc{5}, out_Mth{frame}]    = getPOC(imgFeature0{1,5}, imgFeature1{1,5},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'Mulut'),'Mouth');
%             [poc{6}, out_Frhd{frame}]   = getPOC(imgFeature0{1,6}, imgFeature1{1,6},frame, sprintf('%s/%d_%s',nmFoldRes,frame,'Forehead'),'Forehead');
% 
%         else
% %             disp('d');
%             [poc{frame},output{frame}]      = getPOC(imgFeature0, imgFeature1,frame, sprintf('%s/%s',nmFoldRes,tipeFeat), tipeFeat);
%         end
%     %     hold off;
% 
%         pause(0.001);
%         
        frame = frame + 1;
%     end
% 
%     disp('Get Quiver...........');
%     % Untuk menampilkan data Quiver dataset di Panel Workshop dataQuiver
%     if (strcmp('All',tipeFeat))
%         dataQuiver{1,1} = getCoordinate(out_EBL,sMax); % Cell 1 Alis Kiri
%         dataQuiver{1,2} = getCoordinate(out_EBR,sMax); % Cell 2 Alis Kanan
%         dataQuiver{1,3} = getCoordinate(out_EL,sMax);  % Cell 3 MataKiri
%         dataQuiver{1,4} = getCoordinate(out_ER,sMax);  % Cell 4 Mata Kanan
%         dataQuiver{1,5} = getCoordinate(out_Mth,sMax); % Cell 5 Mulut
%         dataQuiver{1,6} = getCoordinate(out_Frhd,sMax);% Cell 6 Dahi
%     else
%         dataQuiver = getCoordinate(output,sMax); % sesuai tipeFeat
    end
else
    disp('Folder Tidak Ditemukan');
end

