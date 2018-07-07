function [codedFrames, bitstreamF0, framesBistreams] = finalProjectEncoder(sequenceFrames, outputFolder, outputFilename, macroBlockSize, alpha, N) 
% Funcao que recebe sequencia de frames, o nome do
% arquivo de saida, o tamanho do macro bloco na estimacao de movimento, o 
% parametro a ser usado no codificador do projeto 3 e o tamanho do bloco a
% ser usado no codificador do projeto 3

% Retorna os frames codificados, e os bitstreams

addpath('./BlockMatchingAlgoMPEG');
addpath('./SabadoToolbox/');

%% Inicializando as variaveis a serem usadas
finalOutput = [outputFolder outputFilename];
[h, w, c] = size(sequenceFrames(:, :, 1));
cropParameter = 0;
if(h < w)
    cropParameter = h;
else
    cropParameter = w;
end
    
amountFrames = length(sequenceFrames);
sequenceFrames = sequenceFrames(1:cropParameter, 1:cropParameter, :);
firstFrame = sequenceFrames(:, :, 1);


% struct que vai armazenar os bitstreams do motionvector e do residuo para
% cada frame
framesBistreams = struct('motionVector1',{},...
                  'motionVector2',{},...
                  'residual',{});
              

%% Codificacao de video
[codedFrames, bitstreamF0, framesBistreams] = videoEncoder(sequenceFrames, [finalOutput], macroBlockSize, alpha, N);    
    
end