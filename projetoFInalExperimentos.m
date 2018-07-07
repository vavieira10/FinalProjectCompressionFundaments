%% Script que implementa a codificacao do trabalho final

clc;
clear all;
close all;

%% Inicializando as variaveis a serem usadas
alpha = 1; % alphas que serao usados no experimento;
PSNR = zeros(1, 300);
videoFolder = 'Video Database/';
encodedFilesFolder = 'EncodedFilesProjetoFinal/';
videoFile = 'container_qcif_176x144_30.yuv'; % MUDE O NOME DA IMAGEM AQUI
outputFileName = strsplit(videoFile, '_');
outputFileName = outputFileName{1, 1};
N = 8;
macroBlock = 8;

[frames,~,~] = readyuv([videoFolder videoFile],176,144,300);

N = 8;

%% Fazendo os experimentos para cada alpha do codificador do projeto final

[codedFrames, ~, framesBistreams] = finalProjectEncoder(frames, encodedFilesFolder, outputFileName, macroBlock, alpha, N);
decodedFrames = finalProjectDecoder(codedFrames, framesBistreams, macroBlock, alpha, N);

for i = 1:300
    PSNR(i) = psnr(decodedFrames(:, :, i), frames(:, 1:144, i));
end

avgPSNR = mean(PSNR);