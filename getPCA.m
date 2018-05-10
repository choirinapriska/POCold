function [ PC ] = getPCA( dataPOC)
%GETPCA Summary of this function goes here
%   Detailed explanation goes here

sizeDt = size(dataPOC);

pca = zeros(sizeDt(1)*sizeDt(2),sizeDt(3));
disp(size(pca));
for i = 1: size(dataPOC,3)
    data    = dataPOC(:,:,i);
    pca(:,i)  = data(:);
end

imZero = zscore(pca);

[COEFF, SCORE, LATENT] = princomp(imZero);

PC = SCORE(1,1);

end

