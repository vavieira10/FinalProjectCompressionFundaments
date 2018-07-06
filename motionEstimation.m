function [motionVectors, prediction] = motionEstimation(currFrame, refFrame, macroBlockSz)
% Funcao que recebe o frame sendo processado, um frame de referencia e o
% tamanho do macrobloco
% Retorna os vetores de movimento e a predicao 

% As funcoes que calculam os vetores de movimento e a predicao nao sao
% nossas, pertencem a Aroh Barjatya e podem ser encontradas na pasta BlockMatchingAlgoMPEG
% e no link https://www.mathworks.com/matlabcentral/fileexchange/8761-block-matching-algorithms-for-motion-estimation

% O algoritmo sendo usado para o motion estimation eh o Diamond Search Algorithm

[motionVectors, ~] = motionEstDS(currFrame, refFrame, macroBlockSz, 1);
prediction = motionComp(refFrame, motionVectors, macroBlockSz);

end

