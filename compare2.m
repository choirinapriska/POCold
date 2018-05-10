% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Left Eyebrow    = 1 - 5
% % Right Eyebrow   = 6 - 10
% % Left Eyes       = 20 - 25
% % Right Eyes      = 26 - 31
% % Nose            = 11 - 19
% % mouth           = 32 - 49
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

warning('off','images:initSize:adjustingMag');

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

% Subblock 
sb = [15 15];

label      = 'Happiness'; % label for dataset
%nmFold     = 'Happiness/23_EP02_01';
nmFold     = 'coba'; % folder location
is_show    = 'off'; % set figure on or off

% % EOF INPUT USER

nFold      = ['test_images/sequence/' nmFold '/'];
imFol      = dir(fullfile(nFold,'*.jpg'));
imFol      = natsortfiles({imFol.name});
nmFoldRes  = ['results/sequence/' nmFold];
sMax       = size(imFol,2);

curNum     = zeros(1,1,3);

for c = 1 : sb(1)
    nMed = median(1:sb(1));
    
    curNum(c,1,1) = c; %X
    curNum(c,1,2) = c-nMed; %X
    curNum(c,1,3) = nMed-c; %Y
end


disp('Get Data.........');

if(sMax > 0)
    for frame = 1:numel(imFol)
        % % name file
        nameFile1 = [nFold imFol{frame}];
        nameFile2 = [nFold imFol{frame+1}];
      
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
        
        if frame == 1
             points = Fitting(input0,init0,RegMat,MaxIter);
        else
             points = [points(:,1), points(:,2)];
        end

        [imgFeature0,bboxFeat0] = getFeaturesFace(points,input0,tipeFeat);
        [imgFeature1,bboxFeat1] = getFeaturesFace(points,input1,tipeFeat);
               
% %          if(frame == 2)
%              figure, imshow(img0),  title(sprintf('Frame %d',frame));hold on;
%              plot(points(:,1),points(:,2),'g*','MarkerSize',6);  
%              
%              for pn = 1 : size(points,1)
%                  text(points(pn,1),points(pn,2),pn);
%              end
% 
%              rectangle('Position',bboxFeat1{1},'EdgeColor','r') 
%              rectangle('Position',bboxFeat1{2},'EdgeColor','r')
%              rectangle('Position',bboxFeat1{3},'EdgeColor','r')
%              rectangle('Position',bboxFeat1{4},'EdgeColor','r')
%              rectangle('Position',bboxFeat1{5},'EdgeColor','r')
%              rectangle('Position',bboxFeat1{6},'EdgeColor','r')
%            hold off;
% %          end         
    
        numF = 5;
        numCat = size(catTipe,2)-1; 
            
        if(strcmp('All',tipeFeat))
            
            for f = 1 : numCat
                w{f} = figure('Name', num2str(catTipe{f}),'visible',is_show);
                movegui(w{f},locFig{f});
                
                imagesc(imgFeature0{1,f}),xlabel('X'),ylabel('Y'), colormap(gray), title(['Frame' num2str(frame) ' = IMG ' num2str(imFol{frame}) ' -> IMG ' num2str(imFol{frame+1})]);
                hold on;
            
                [poc{f}, output{frame,f}]    = getPOC(imgFeature0{1,f}, imgFeature1{1,f},frame,catTipe{f});
                
                hName = {['Rx' catTipe{f}] ['Ry' catTipe{f}] ['R' catTipe{f}] ['Teta' catTipe{f}] ['Sum' catTipe{f}]};
                hPola = {['RxMean' catTipe{f}] ['RyMean' catTipe{f}] ['RMean' catTipe{f}] ['TMean' catTipe{f}] ...
                         ['RxMed' catTipe{f}] ['RyMed' catTipe{f}] ['RMed' catTipe{f}] ['TMed' catTipe{f}] ...
                         ['RxMod' catTipe{f}] ['RyMod' catTipe{f}] ['RMod' catTipe{f}] ['TMod' catTipe{f}] ...
                         ['Sum' catTipe{f}]};
                
                if f == 1
                    disp('ddd');
                    last  = numF+1;
                    first = 1;
                    
                    header(1,1)= {'Frame'};
                    header(1,first:last) = hName;
                    
                    lastP  = (f*size(hPola,2))+1;
                    firstP = first;
                    
                    headP(1,1) = {'Frame'};
                    headP(1,firstP+1:lastP) = hPola;
                else     
                    
                    last  = f*(numF)+1;
                    first = (last-(numF))+1;
                    
                    header(1,first:last)= hName;
                    
                    lastP  = f*size(hPola,2)+1;
                    firstP = (lastP-(size(hPola,2)))+1;
                    
                    %disp([num2str(firstP) '-' num2str(lastP) ]);
                    headP(1,firstP:lastP) = hPola;
                end
                disp(first)
                disp(last)
%                 [quiv(frame,first:last), pola(frame,firstP:lastP)]  = getCoordinate(output{frame,f},frame, catTipe{f},first);
               
                if f == numCat    
                    header(1,last+1)= {'Label'};
                    quiv(frame,last+1) = {label};
                    
                    headP(1,lastP+1)= {'Label'};
                    pola(frame,lastP+1) = {label};
                end
%                 disp([num2str(first) ' : ' num2str(last) ' | ' num2str(last-first) ' | ' num2str(size(quiv,2)) ]);
            end
            
        else
            w = figure('Name', num2str(tipeFeat),'visible',is_show);
            movegui(w,locFig{1});
            
            imagesc(imgFeature0),xlabel('X'),ylabel('Y'), colormap(gray), title(['Frame' num2str(frame) ' = IMG ' num2str(imFol{frame}) ' -> IMG ' num2str(imFol{frame+1})]);
            hold on;
            
            header = {'Frame' ['Rx' tipeFeat] ['Ry' tipeFeat] ['R' tipeFeat] ['Teta' tipeFeat] ['Sum' tipeFeat] ['Label' tipeFeat]};
            headP = {'Frame' ['RxMean' tipeFeat] ['RyMean' tipeFeat] ['RMean' tipeFeat] ['TMean' tipeFeat] ...
                             ['RxMed' tipeFeat] ['RyMed' tipeFeat] ['RMed' tipeFeat] ['TMed' tipeFeat] ...
                             ['RxMod' tipeFeat] ['RyMod' tipeFeat] ['RMod' tipeFeat] ['TMod' tipeFeat] ...
                             ['Sum' tipeFeat] ['Label']...
                    };
            
            [poc{frame},output{frame}]  = getPOC(sb,imgFeature0, imgFeature1,frame, tipeFeat);
            [quiv(frame,1:6), pola(frame,1:14)]= getCoordinate(curNum,output{frame},frame, '',1);
            quiv(frame,7:7) = {label};
            pola(frame,15:15) = {label};
            
            pca{frame} = getPCA(poc{frame});
        end
        
        disp(['=========================' num2str(frame) '===============================']);
        
        if strcmp(is_show, 'on')
            hold off;
            pause;
            close all;
        end
        
    end
  
    dataQv  = array2table(quiv,'VariableNames',header);
    dataPola = array2table(pola,'VariableNames',headP);
else
    disp('Folder Tidak Ditemukan');
end

