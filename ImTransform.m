%% Victor Araujo Vieira - 14/0032801
%% Script que implementa o codificador de imagens CIQA

close all;
clear all;
clc;

imageFile = 'lena.bmp';
image = imread(imageFile);
M = [2 4 8 16];
N = [4 8 16 32];
amountTests = length(M)*length(N); % numero de vezes que o encoder sera rodado
pSNR = zeros(amountTests, 1);
mse = zeros(amountTests, 1);
R = zeros(amountTests, 1);
decodedImage = zeros(size(image, 1), size(image, 2));

% Vai executar o encoder para todos os pares possiveis de M,N
counter = 1;
for i = 1:length(M)
    for j = 1:length(N)
    M(i)
    N(j)
    fileToBeCoded = ['ciqaM' num2str(M(i)) 'N' num2str(N(j))];
    tic
    ciqaEncoder(image, fileToBeCoded, M(i), N(j));
    toc
    fileToBeDecoded = [fileToBeCoded '.bin'];
    tic
    decodedImage = ciqaDecoder(fileToBeDecoded);
    toc
    imwrite(decodedImage, [fileToBeCoded '.png']);
    mse(counter) = immse(decodedImage, image);
    pSNR(counter) = psnr(decodedImage, image);
    R(counter) = (16 + (N(j).^2)*log2(M(i)))/N(j).^2;
    groups{counter} = ['M = ' num2str(M(i)) ', N = ' num2str(N(j))];
    %imshow(decodedImage);title(['Imagem codificada com M = ', num2str(M(i)),' e N = ', num2str(N(j))]);figure;
    counter = counter + 1;
    end
end
groups = groups';
gscatter(mse, R, groups);


