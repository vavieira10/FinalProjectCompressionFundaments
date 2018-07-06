%% Script que implementa a codificacao do trabalho 3

clc;
clear all;
close all;

%% Inicializando as variaveis a serem usadas
alphas = [0.05, 0.1, 0.3, 0.5, 0.7, 1, 1.3, 1.5, 1.7, 3, 4, 5, 7, 9, 10]; % alphas que serao usados no experimento;
amountAlphas = length(alphas);
R = zeros(1, amountAlphas);
PSNR = zeros(1, amountAlphas);
MSE = zeros(1, amountAlphas);
imageFolder = 'Image Database/';
resultImageFolder = 'Result_Image/';
imageFile = 'lena.bmp';
imageName = strsplit(imageFile, '.');
imageName = imageName{1, 1};
image = imread([imageFolder imageFile]);
[h, w, c] = size(image);

%% Fazendo os experimentos para cada alpha do codificador do projeto 3
for i = 1:amountAlphas
    outputFile = [imageName '_Alpha' num2str(alphas(i))];
    codedBlocks = project3Encoder(image, outputFile, alphas(i));
    decodedImage = imTransformDecoder(codedBlocks, h, w, alphas(i));
    imwrite(decodedImage, [resultImageFolder outputFile '.png']);
    groups{i} = ['Alpha = ' num2str(alphas(i))];
    
    % pega o tamanho do arquivo binario gerado e calcula a taxa a partir
    % disso
    encodedFile = dir([outputFile '.bin']);
    fileSize = encodedFile.bytes;
    R(i) = (fileSize*8)/(h*w); % numero de bytes * 8 bits / (numero total de pixels da imagem)
    PSNR(i) = psnr(decodedImage, image);
    MSE(i) = immse(decodedImage, image);
end

groups = groups';
gscatter(MSE, R, groups);