function [result,bboxF] = getFeaturesFace( test_points, test_input_image, type )
%GETFEATURES Summary of this function goes here
%   Detailed explanation goes here

xPoint = test_points(:,1);
yPoint = test_points(:,2);

% EBLeft  = [ceil(yPoint(2)-40),ceil(yPoint(2)-30) ,(ceil(xPoint(5)-xPoint(1))+15) , (ceil((xPoint(5)-xPoint(1))/2) +10)];
% EBRight = [ceil(xPoint(6))-15,ceil(yPoint(2)-30) ,(ceil(xPoint(5)-xPoint(1))+15) , (ceil((xPoint(5)-xPoint(1))/2) +10)];
% EyLeft  = [ceil(xPoint(20)-15),ceil(yPoint(22)-15),(ceil(xPoint(5)-xPoint(1))+15)-30 , (ceil((xPoint(5)-xPoint(1))/2) +10)-15];
% EyRight = [ceil(xPoint(26)-15),ceil(yPoint(22)-15),(ceil(xPoint(5)-xPoint(1))+15)-30 ,(ceil((xPoint(5)-xPoint(1))/2) +10)-15];
% MouthB  = [ceil(xPoint(32)-20),ceil(yPoint(34)-18),ceil((xPoint(38)) - (xPoint(32))) + 40,  ceil((yPoint(41)-yPoint(34))+40)];
% ForeheadB = [ceil(xPoint(3)+20),ceil(xPoint(3)-70), EBLeft(3), EBLeft(4)];

EBLeft  = [ceil(yPoint(2)-40),ceil(yPoint(2)-30) ,111,58];
EBRight = [ceil(xPoint(6))-15,ceil(yPoint(2)-30) ,111,58];
EyLeft  = [ceil(xPoint(20)-15),ceil(yPoint(22)-15),81,43];
EyRight = [ceil(xPoint(26)-15),ceil(yPoint(22)-15),81,43];

MouthB  = [ceil(xPoint(32)-20),ceil(yPoint(34)-18),139,79];

ForeheadB = [ceil(xPoint(3)+20),ceil(xPoint(3)-70), 111,58];

bboxF   = {EBLeft, EBRight, EyLeft, EyRight, MouthB, ForeheadB};
% disp([frame char(9) ...
%      num2str(EBLeft(3)) char(9) num2str(EBLeft(4)) char(9)...
%      num2str(EBRight(3)) char(9) num2str(EBRight(4)) char(9)...
%      num2str(EyLeft(3)) char(9) num2str(EyLeft(4)) char(9)...
%      num2str(EyRight(3)) char(9) num2str(EyRight(4)) char(9)...
%      num2str(MouthB(3)) char(9) num2str(MouthB(4))  char(9)...
%      num2str(ForeheadB(3)) char(9) num2str(ForeheadB(4))]);
% sAll = cell(4,1);

switch type
    case 'AlisKiri'        
        result  = imcrop(test_input_image,EBLeft);
    case 'AlisKanan'
        result = imcrop(test_input_image,EBRight);
    case 'MataKiri'        
        result  = imcrop(test_input_image,EyLeft);
    case 'MataKanan'        
        result = imcrop(test_input_image,EyRight);
    case 'Mulut'
        result  = imcrop(test_input_image,MouthB);
    case 'Dahi'
        result  = imcrop(test_input_image,ForeheadB);
    case 'All'
        result{1} = imcrop(test_input_image,EBLeft);
        result{2} = imcrop(test_input_image,EBRight);
        result{3} = imcrop(test_input_image,EyLeft);
        result{4} = imcrop(test_input_image,EyRight);
        result{5} = imcrop(test_input_image,MouthB);
        result{6} = imcrop(test_input_image,ForeheadB);
       
%         all  = [result1; result2; result3; result4; result5];
    otherwise
        result = [];
        disp('isi tipenya');
end
   
% imshow(result);
end
            
