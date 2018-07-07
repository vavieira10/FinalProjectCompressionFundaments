function [decodedFrameSequence] = finalProjectDecoder(codedFrames, bitstreams, macroBlockSize, alpha, N) 
% Funcao que recebe uma lista de de arquivos a serem decodificados,
% o tamanho do macro bloco na estimacao de movimento, o 
% parametro a ser usado no codificador do projeto 3 e o tamanho do bloco a
% ser usado no codificador do projeto 3

% Retorna os blocos decodificados

addpath('./BlockMatchingAlgoMPEG');
addpath('./SabadoToolbox/');

%% Decodifica os motion vectors
motionVectors = decodeMotionVectors(bitstreams);

[decodedFrameSequence] = videoDecoder(codedFrames, motionVectors, macroBlockSize, alpha, N);
    
end