function [decodedFrames] = videoDecoder(codedFrames, motionVectors, macroBlockSize, alpha, N) 
% Funcao que recebe umasequencia de frames, o nome do
% arquivo de saida, o tamanho do macro bloco na estimacao de movimento, o 
% parametro a ser usado no codificador do projeto 3 e o tamanho do bloco do
% codificador do projeto 3

% Retorna os frames codificados, e os bitstreams

%% Inicializando as variaveis a serem usadas
[h, w, c] = size(codedFrames(:, :, 1));
cropParameter = 0;
if(h < w)
    cropParameter = h;
else
    cropParameter = w;
end
    
amountFrames = length(codedFrames);
codedFrames = codedFrames(1:cropParameter, 1:cropParameter, :);

decodedFrames = zeros(cropParameter, cropParameter, amountFrames);
decodedFrames(:, :, 1) = codedFrames(:, :, 1);

%% Decodificar o resto dos frames
refFrame = decodedFrames(:, :, 1);
for f = 2:amountFrames
    currFrame = codedFrames(:, :, f);
    P = motionComp(refFrame, motionVectors(:, :, f - 1), macroBlockSize);
    
    decodedFrames(:, :, f) = P + currFrame;
    
    refFrame = refFrame - currFrame; % o novo frame de referencia eh a soma da referencia passada com o residuo
end

decodedFrames = uint8(decodedFrames);
    
end