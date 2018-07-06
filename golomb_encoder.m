%%Fun��o que implementa a codifica��o dos vetores de movimento por
%%Exp-Golomb de ordem K = 0. C�digo feito para aceitar n�meros com sinal e
%%retorna uma string com o bitstream de todos os simbolos juntos.

function [bitstream1, bitstream2] = golomb_encoder(motionVectors)
bitstream1 = '';
bitstream2 = '';
[~,N] = size(motionVectors);
for i = 1:1:N
    if motionVectors(1, i) == 0
        motionVectors(1, i) = motionVectors(1, i);
    elseif motionVectors(1, i)>0
        motionVectors(1, i) = 2*motionVectors(1, i)-1; %remapeia numeros positivos para um outro numero impar.
    else
        motionVectors(1, i) = -2*motionVectors(1, i); %remapeia numeros negativos para um positivo par.
    end
    q = floor(log2(motionVectors(1, i) + 1)); %linhas 15 e 16 reescrevem o numero em binario de acordo com o algoritmo Exp-Golomb
    x = dec2bin(motionVectors(1, i) + 1 - 2^q,q);
    for j=1:q
        bitstream1 = [bitstream1 '0']; %enche bitstream com o numero de zeros igual a q.
    end
    aux='1';
    bitstream1 = strcat(bitstream1,aux); %concatena o 1 aos zeros
    bitstream1 = strcat(bitstream1,x);%concatena x ao resto da string
    
    if motionVectors(2, i) == 0
        motionVectors(2, i) = motionVectors(2, i);
    elseif motionVectors(2, i)>0
        motionVectors(2, i) = 2*motionVectors(2, i)-1; %remapeia numeros positivos para um outro numero impar.
    else
        motionVectors(2, i) = -2*motionVectors(2, i); %remapeia numeros negativos para um positivo par.
    end
    q = floor(log2(motionVectors(2, i) + 1)); %linhas 15 e 16 reescrevem o numero em binario de acordo com o algoritmo Exp-Golomb
    x = dec2bin(motionVectors(2, i) + 1 - 2^q,q);
    for j=1:q
        bitstream2 = [bitstream2 '0']; %enche bitstream com o numero de zeros igual a q.
    end
    aux='1';
    bitstream2 = strcat(bitstream2,aux); %concatena o 1 aos zeros
    bitstream2 = strcat(bitstream2,x);%concatena x ao resto da string
end

end