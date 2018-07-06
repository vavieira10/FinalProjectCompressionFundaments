function [codedBlocks, bitstream] = project3Encoder(image, outputFile, alpha, N) 
% Funcao que recebe uma umagem, o nome do
% arquivo de saida, o parametro a ser usado na codificacao e o tamanho do
% bloco a ser usado

% Retorna os blocos codificados, a entropia, comprimento medio e
% redundancia da codificacao Huffman


%% Leitura da imagem
[h, w, c] = size(image); % altura, comprimento e canais da imagem

%% Codificacao da imagem usando o codificador do trabalho 3
codedBlocks = imTransformEncoder(image, alpha, N);

% Gerando a string que sera usada para fazer a codificacao huffman
stringToBeEncoded = generateStringBlocks(codedBlocks);

%% Codificacao Huffman
symbAndProbabs = structGenerator(stringToBeEncoded);

% Calculando a entropia
huffmanEntropy = calculaEntropia(symbAndProbabs);

% Codificacao pelo algoritmo huffman e calculo do comprimento medio
% Chamada do algoritmo de huffman, que vai retornar a arvore huffman e uma
% tabela com os simbolos e seus respectivos codigos
[huffmanTree, codesTable] = codHuffman(symbAndProbabs);

% Calculo do comprimento medio e da redundancia
huffmanAvgLength = calculaComprMedio(symbAndProbabs, codesTable);

huffmanRedudancy = huffmanAvgLength - huffmanEntropy;

% Chamada do codificador de huffman, que vai retornar um bitstream para ser
% escrito no arquivo final codificado
bitstream = huffmanEncoder(codesTable, stringToBeEncoded);

% Escrevendo o arquivo comprimido
outputFile = [outputFile '.bin']; % concatena nome original com .bin no final
escreveBitstream(outputFile, bitstream, codesTable, h, w, alpha);


end