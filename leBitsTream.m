% function bitstream = readBitstreamFromFile(filename)
%
%  L� um bitstream de um arquivo.
% - Recebe como par�metro:
%   filename : o nome do arquivo.
%
% - Retorna: 
%    bitstream: o bitstream lido.
%    cabecalho: cabecalho que contem os simbolos e seus codigos
%
function [bitstream, alfabeto, codigos, h, w, alpha] = leBitsTream(filename, tipoArq)

%Abre o arquivo
fid = fopen(filename,'rb');

%L� o n�mero de bits escrito.
n = fread(fid, 1, 'uint32');

h = fread(fid, 1, 'uint16'); % altura da imagem
w = fread(fid, 1, 'uint16'); % largura da imagem
alpha = fread(fid, 1, 'double');

%Calcula o n�mero de bytes escrito.
n8 = ceil(n/8);

% Le o tamanho do header
nH = fread(fid, 1, 'uint16');

% Le o header no arquivo
cabecalho = fread(fid, nH, 'uint8=>char');

cabecalho = cabecalho';

%L� todos os bytes.
bitstream2 = fread(fid, n8, 'uint8');

%Fecha o arquivo.
fclose(fid);

% para o decodificador
cabecalho = strsplit(cabecalho, '`|'); % separando cada [Simb, Codigo] do cabecalho que foram separados pelo char '`'
temp = {}; 
for i = 1:length(cabecalho)
   temp{i} = strsplit(char(cabecalho{i}), ', '); 
end

% Gerando os cells alfabeto e codigos
alfabeto = {};
codigos = {};
temp2 = {};
for i = 1:length(temp)
    temp2 = temp{i};
    alfabeto{i} = temp2(1);
    codigos{i} = temp2(2);
end

% Se tipoArq for 0, alfabeto vai ser convertido para uint8
if(tipoArq == 0)
    for i = 1:length(alfabeto)
        alfabeto{i} = uint8(alfabeto{1, i}{1, 1}); 
    end
end


%Converte os bytes em um array de bits.
bitstream = zeros(n8 * 8, 1);
for (i = 1:1:n8)
    bitstream((i-1)*8 + 1: i*8) = dec2bin(bitstream2(i),8);
end

%Remove os bits excedentes.
bitstream = char(bitstream(1:n)');
