function [output,outputSum,panah, header] = getCoordinate(list,frame, feature,num,poc)   
   cur_x = [1;2;3;4;5;6;7;8;9];
   rep_x = [-4;-3;-2;-1;0;1;2;3;4];

   cur_y = [1;2;3;4;5;6;7;8;9];
   rep_y = [4;3;2;1;0;-1;-2;-3;-4];
   
   data = list;

   dataX = data(:,:,1); 
   dataY = data(:,:,2);
   dataU = data(:,:,3);
   dataV = data(:,:,4);
   dataA = rep_x(cur_x(data(:,:,5)));
   dataB = rep_y(cur_y(data(:,:,6)));
   
   disp(reshape(dataA,[],1));
   disp('===================A========================');
   disp(reshape(dataB,[],1));
   disp('===================B========================');
   
   sm = (size(dataX,1)*size(dataX,2));
   
   rX = sum(sum(dataA));
   rY = sum(sum(dataB));
   
   magR = (rX * rX) + (rY * rY) ;
   magR = sqrt(magR);
   
   if rX == 0 && rY < 0 
       divM = 0;
   else
       divM = (rY / rX);
   end

   teta = atan2(rY,rX)*180/3.14;   
   
   dataQuiver   = zeros(size(dataX,1),size(dataX,2),4);
  
   sQ = 0; 
   sB = 0;
         
   for y = 1: size(dataX,1)
        for x = 1 :size(dataX,2)
            qX = dataX(y,x);
            qY = dataY(y,x);
            qU = dataU(y,x);
            qV = dataV(y,x);
            qA = dataA(y,x);
            qB = dataB(y,x);
            
             
             
            if qA ~= 0  || qB ~= 0

               p1 = [qX qY]; % nilai pindah
               p2 = [qU qV]; % nilai Tengah

               dp = p2-p1;

               dataQuiver(y,x,1) = p1(1);
               dataQuiver(y,x,2) = p1(2);
               dataQuiver(y,x,3) = dp(1);
               dataQuiver(y,x,4) = dp(2);    
               
               sQ = sQ +1;
            else
               dataQuiver(y,x,1) = 0;
               dataQuiver(y,x,2) = 0;
               dataQuiver(y,x,3) = 0;
               dataQuiver(y,x,4) = 0;
            end  
            
           sB = sB + 1;
           
            wX = qA;
            wY = qB;
            
           magtR = (wX * wX) + (wY * wY) ;
           if(magtR ~=0)
               mag{sB} = sqrt(magtR);
           else
               mag{sB} = 0;
           end

           tetha{sB} = atan2(wY,wX)*180/3.14;  

            panah1{sB} = dataQuiver(y,x,3);
            panah2{sB} = dataQuiver(y,x,4);
            
            header1{sB} = ['X' num2str(sB) ]; 
            header2{sB} = ['Y' num2str(sB)];
            header3{sB} = ['Magnitude' num2str(sB)];
            header4{sB} = ['Tetha' num2str(sB)];
            
        end
   end
 
   panah   = [panah1 panah2 mag tetha];
   header  = [header1 header2 header3 header4];
   
%    disp(panah);
   
   outputSum = {num2str(sQ)};
      
   if num == 1      
       output = {num2str(frame) num2str(rX) num2str(rY) num2str(magR) num2str(teta) num2str(sQ)} ; 
   else
       output = {num2str(rX) num2str(rY) num2str(magR) num2str(teta) num2str(sQ)} ;
   end
%    disp(outputPanah);
%  disp(dataQuiver);
%    disp(['Frame' num2str(frame)...
%        ' | rX : ' num2str(rX) ...
%        ' | rY : ' num2str(rY)...
%        ' | Magnitude : ' num2str(magR)...
%        ' | Tan : ' num2str(tan)...
%        ' | Teta : ' num2str(teta)...
%        ]);
   
 
   quiver(dataQuiver(:,:,1),dataQuiver(:,:,2),dataQuiver(:,:,3),dataQuiver(:,:,4),0,'Color','r','Linewidth',1.5);
 
end

