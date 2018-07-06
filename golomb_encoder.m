%%Fun��o que implementa a codifica��o dos vetores de movimento por
%%Exp-Golomb de ordem K = 0. C�digo feito para aceitar n�meros com sinal e
%%retorna uma string com o bitstream de todos os simbolos juntos.

function [bitstream] = golomb_encoder(motionVectors)
bitstream = '';
[~,N] = size(motionVectors);
for i = 1:1:N
    if motionVectors(i) == 0
        motionVectors(i) = motionVectors(i);
    elseif motionVectors(i)>0
        motionVectors(i) = 2*motionVectors(i)-1; %remapeia numeros positivos para um outro numero impar.
    else
        motionVectors(i) = -2*motionVectors(i); %remapeia numeros negativos para um positivo par.
    end
    q = floor(log2(motionVectors(i) + 1)); %linhas 15 e 16 reescrevem o numero em binario de acordo com o algoritmo Exp-Golomb
    x = dec2bin(motionVectors(i) + 1 - 2^q,q);
    for j=1:q
        bitstream = [bitstream '0']; %enche bitstream com o numero de zeros igual a q.
    end
    aux='1';
    bitstream = strcat(bitstream,aux); %concatena o 1 aos zeros
    bitstream = strcat(bitstream,x);%concatena x ao resto da string
end

end