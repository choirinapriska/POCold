close all; clc;

img1 = rgb2gray(imread('test_images/sequence/coba2/1.jpg'));
img1 = imresize(img1,[53 47]);
img(:,1) = img1(:);

img2 = rgb2gray(imread('test_images/sequence/coba2/2.jpg'));
img2 = imresize(img2,[53 47]);
img(:,2) = img2(:);

img3 = rgb2gray(imread('test_images/sequence/coba2/3.jpg'));
img3 = imresize(img3,[53 47]);
img(:,3) = img3(:);

img = double(img);
imZero = zscore(img);

% Coeff = menyimpan nilai koefisien dari pca
% latent = menyimpan varians dari pca
% score = value pca , row paling atas nilai penting 

[COEFF, SCORE, LATENT] = princomp(imZero);

PC = SCORE(1:100,:);

