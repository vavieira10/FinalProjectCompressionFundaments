%% Script que implementa a decodificacao de uma fonte

clc;
clear all;
close all;

tic
%% Leitura do arquivo codificado
% Le o arquivo codificado e retorna o bitstream, alfabeto e os codigos da
% fonte original codificada

fileName = 'lena.bin'; % MUDE O NOME DO ARQUIVO
fileType = 2; % SE FOR 1 EH TXT, SENAO EH QUALQUER OUTRO FORMATO DE ARQUIVO

[bitstream, alphabet, codes] = leBitsTream(fileName, fileType);


%% Decodificacao huffmann do bitstream 
% Chamada do decoder de huffman, que vai retornar a sequencia original do
% arquivo codificado
originalSequence = huffmanDecoder(bitstream, alphabet, codes, fileType);
originalSequence = char(originalSequence);
originalSequence = originalSequence';
originalSequence = strsplit(originalSequence, char(10)); % separando a string pela quebra de linha

%% Decodificacao do codificador do trabalho 3
% A partir da sequencia original, reconstruir a struct com a contagem de 0s
% e o vetor reordenado apos o run length coding de cada bloco


codedBlocks = struct('runLengthArray',{},...
                  'countOfZeros',{});
% o vetor sempre vai ter um elemento a mais, por isso o -1 no loop
amountBlocks = length(originalSequence) - 1;
for i = 1:amountBlocks
   block = strsplit(originalSequence{i}, ' '); % quebrando a string de cada bloco pelo espaco
   tempArray = zeros(length(block) - 1, 1);
   % Loop pra montar o run length array
   for j = 1:length(tempArray)
       tempArray(j, 1) = str2num(block{j + 1});
   end
   x.runLengthArray = tempArray;
   x.countOfZeros = str2num(block{1});
   codedBlocks(end + 1) = x;
end

toc