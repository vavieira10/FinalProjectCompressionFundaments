function [decodedFrameSequence] = finalProjectDecoder(inputFiles, macroBlockSize, alpha) 
% Funcao que recebe uma lista de de arquivos a serem decodificados,
% o tamanho do macro bloco na estimacao de movimento e o 
% parametro a ser usado no codificador do projeto 3

% Retorna os blocos decodificados

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
framesBistreams = struct('motionVector',{},...
                  'residual',{});
              

%% Codificando o primeiro frame (frame intra) usando o codificador do projeto 3
[codedBlocksFirstFrame, bitstreamF0] = project3Encoder(firstFrame, [finalOutput 'F1'], alpha);
% ao inves de chamar o decodificador que tem que decodificar o huffma, chama o decodificador ja em posso dos blocos codificados
decodedFrame = imTransformDecoder(codedBlocksFirstFrame, cropParameter, cropParameter, alpha);

%% Codificar o resto dos frames
refFrame = decodedFrame;
for f = 2:amountFrames
    currFrame = sequenceFrames(:, :, f);
    [motionVectors, P] = motionEstimation(currFrame, refFrame, macroBlockSize); % calculando os vetores de movimento e a predicao P
    bitstreamMV = golomb_encoder(motionVectors); % gerando o bistream dos motion vectors usando codificacao Exp-Golomb
    R = currFrame - P; % calculando o residuo do frame atual
    
    % codificando a imagem de residuo
    [codedBlocksResidual, bitstreamR] = project3Encoder(R, [finalOutput 'F' num2str(f)], alpha); % codifica a imagem de residuo com o cdificador do projeto 3
    decodedResidual = imTransformDecoder(codedBlocksResidual, cropParameter, cropParameter, alpha);
    
    % salvando na struct dos bitstreams
    x.motionVector = bitstreamMV; % x eh uma struct temporaria
    x.residual = bitstreamR;
    framesBistreams(end + 1) = x;
    
    refFrame = refFrame + decodedResidual; % o novo frame de referencia eh a soma da referencia passada com o residuo
end
    
    
end