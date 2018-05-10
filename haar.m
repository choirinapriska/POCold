clear all
clc,
close all
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);


nFold      = 'test_images/sequence/coba/';
imFol      = dir(fullfile(nFold,'*.jpg'));
imFol      = natsortfiles({imFol.name});
nmFoldRes  = 'results/sequence/coba/';
sMax       = size(imFol,2);

if(sMax > 0)
    for frame = 1:numel(imFol)
        %Read the input image
        I = imread([nFold imFol{frame}]);

        %Returns Bounding Box values based on number of objects
        BB = step(FDetect,I);
        I = imcrop(I, BB);

        BBEye=step(EyeDetect,I);
        BBNose=step(NoseDetect,I);
        BBMouth = step(MouthDetect,I);

        figure,
        imshow(I); hold on
        
        if ~isempty(BBEye)
            rectangle('Position',BBEye(1,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
        end
        
        if ~isempty(BBNose)
             for i = 1:size(BBNose,1)
                rectangle('Position',BBNose(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','y');
            end
        end
        
        if ~isempty(BBMouth)
            rectangle('Position',BBMouth(2,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
        end


        % for i = 1:size(BB,1)
        %     rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
        % end
        title('Face Detection');

        hold off;
    end
end