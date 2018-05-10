function [ test_input_image, test_init_shape ] = getLandmark( test_image,refShape,bbox )
%GETLANDMARK Summary of this function goes here
%   Detailed explanation goes here
             
%     bbox = [bbox(1), bbox(2)+];
    test_init_shape = InitShape(bbox,refShape);
    test_init_shape = reshape(test_init_shape,49,2);
    
    if size(test_image,3) == 3
        test_input_image = im2double(rgb2gray(test_image));
    else
        test_input_image = im2double((test_image));
    end
end

