function [poc, outputAll] = getPOC( imgBlockCur, imgBlockRef ,frame, type)
%GETPOC Summary of this function goes here
%   Detailed explanation goes here    
    mb_x = 9;
    mb_y = 9;   
    
    medX = median(1:mb_x)-1;
    medY = median(1:mb_y)-1;
    
    T       = mb_x;
    window  = hann(T);
    window  = window.'*window;
    
    im0     = double(imgBlockCur);
    im1     = double(imgBlockRef);
    
    [cols, rows, ~] = size(im0);
    
    cy   = floor(cols/mb_y);
    cx   = floor(rows/mb_x);
    
    poc  = zeros(mb_x,mb_y);
    cb   = zeros(size(imgBlockCur));
    num  = 1;        
    
    for y = 1 : (cols /mb_y)
        for x = 1 : (rows/mb_x)
            corX = x*mb_x;
            corY = y*mb_y;
            
            block_ref   = imcrop(im0,[corX,corY,mb_x-1,mb_y-1]);
            block_curr  = imcrop(im1,[corX,corY,mb_x-1,mb_y-1]);

            fft_ref  = fft2(block_ref.*window,mb_y,mb_x); 
            fft_curr = fft2(block_curr.*window,mb_y,mb_x);
            
            R1  = fft_curr.*conj(fft_ref);
            R2  = abs(R1);
            R2(R2==0)=1e-31;
            R   = R1./R2;
            r   = fftshift(abs(ifft2(R)));

            poc(:,:,num) = r;
            
            [temp_y, temp_x]=find(r==max(max(r)));
            
            if(size(temp_y,1) > 1 || size(temp_x,1) > 1)
                temp_y = 5;
                temp_x = 5;
            end
            
            % nilai tengah
            tX = corX-medX;
            tY = corY-medY;
            
            text(tX,tY, num2str(num),'Color','w');
            
            mX = (corX - (mb_x-temp_x));
            mY = (corY - (mb_y-temp_y));
            
            
            outputAll(y,x,1) = tX;
            outputAll(y,x,2) = tY;
            outputAll(y,x,3) = mX;
            outputAll(y,x,4) = mY;
            outputAll(y,x,5) = temp_x;
            outputAll(y,x,6) = temp_y;
           
%            data(num,:) = {frame,num,temp_x,temp_y,x,y,max(max(r)),type,cx,cy,imgBlockCur,corX,corY};
          
          num = 1+num;            
        end
    end
    
%      outputOld = cell2table(data,'VariableNames',{'Frame';'Blok_Ke'; 'RealX';'RealY';'BLokX';'BlokY'; 'NilaiMaxPOC';'Type';'Qx';'Qy';'ImgBlock';'corX';'corY'});         
%      disp(outputOld)
    
end