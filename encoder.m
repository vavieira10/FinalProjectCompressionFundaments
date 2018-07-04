%% Script que implementa a codificacao de uma fonte

clc;
clear all;
close all;

tic
%% Leitura da imagem
% Le uma imagem
imageFolder = 'Image Database/';
inputImage = 'lena.bmp';  % MUDE O NOME DO ARQUIVO
image = imread([imageFolder inputImage]);
outputFile = strsplit(inputImage, '.');
outputFile = outputFile(1);

%% Codificacao da imagem usando o codificador do trabalho 3
alpha = 1.2;
codedBlocks = imTransformEncoder(image, alpha);

% Gerando a string que sera usada para fazer a codificacao huffman
stringToBeEncoded = generateStringBlocks(codedBlocks);

%% Codificacao Huffman
symbAndProbabs = structGenerator(stringToBeEncoded);

% Calculando a entropia
entropia = calculaEntropia(symbAndProbabs);
entropia

% Codificacao pelo algoritmo huffman e calculo do comprimento medio
% Chamada do algoritmo de huffman, que vai retornar a arvore huffman e uma
% tabela com os simbolos e seus respectivos codigos
[huffmanTree, codesTable] = codHuffman(symbAndProbabs);

% Calculo do comprimento medio e da redundancia
comprMedio = calculaComprMedio(symbAndProbabs, codesTable);
comprMedio
redundancia = comprMedio - entropia;
redundancia

% Chamada do codificador de huffman, que vai retornar um bitstream para ser
% escrito no arquivo final codificado
bitstream = huffmanEncoder(codesTable, stringToBeEncoded);

% Escrevendo o arquivo comprimido
outputFile = [outputFile{1, 1} '.bin']; % concatena nome original com .bin no final
escreveBitstream(outputFile, bitstream, codesTable);
toc