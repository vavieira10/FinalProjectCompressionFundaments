function [codedBlocks, bitstream] = project3Encoder(image, outputFile, alpha) 
% Funcao que recebe uma umagem, o nome do
% arquivo de saida e o parametro a ser usado na codificacao

% Retorna os blocos codificados, a entropia, comprimento medio e
% redundancia da codificacao Huffman

tic
%% Leitura da imagem
[h, w, c] = size(image); % altura, comprimento e canais da imagem

%% Codificacao da imagem usando o codificador do trabalho 3
codedBlocks = imTransformEncoder(image, alpha);

% Gerando a string que sera usada para fazer a codificacao huffman
stringToBeEncoded = generateStringBlocks(codedBlocks);

%% Codificacao Huffman
symbAndProbabs = structGenerator(stringToBeEncoded);

% Calculando a entropia
huffmanEntropy = calculaEntropia(symbAndProbabs);
huffmanEntropy

% Codificacao pelo algoritmo huffman e calculo do comprimento medio
% Chamada do algoritmo de huffman, que vai retornar a arvore huffman e uma
% tabela com os simbolos e seus respectivos codigos
[huffmanTree, codesTable] = codHuffman(symbAndProbabs);

% Calculo do comprimento medio e da redundancia
huffmanAvgLength = calculaComprMedio(symbAndProbabs, codesTable);
huffmanAvgLength
huffmanRedudancy = huffmanAvgLength - huffmanEntropy;
huffmanRedudancy

% Chamada do codificador de huffman, que vai retornar um bitstream para ser
% escrito no arquivo final codificado
bitstream = huffmanEncoder(codesTable, stringToBeEncoded);

% Escrevendo o arquivo comprimido
outputFile = [outputFile '.bin']; % concatena nome original com .bin no final
escreveBitstream(outputFile, bitstream, codesTable, h, w, alpha);
toc

end