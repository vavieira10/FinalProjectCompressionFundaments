function [motionVectors] = decodeMotionVectors(framesBitstreams)
% Funcao que recebe os bitstreams dos vetores de movimento e retorna todos
% os vetores de movimento

amountMV = length(framesBitstreams);
motionVectors = zeros(2, 81, amountMV);

for i = 1:amountMV
    mvDim1 = golomb_decoder(framesBitstreams(i).motionVector1);
    mvDim2 = golomb_decoder(framesBitstreams(i).motionVector2);
    motionVectors(1, :, i) = mvDim1;
    motionVectors(2, :, i) = mvDim2;
end


end

