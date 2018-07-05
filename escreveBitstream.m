function escreveBitstream(nomeArquivo, bitstream, SimbCodigos, h, w, alpha)
% Funcao que recebe o bitsream gerado pelo codificador huffman e gera o
% arquivo comprimido, com o devido cabecalho

%% Inicializacao de variaveis para gerar o cabecalho
% O cabecalho vai ter a seguinte estrutura {Simb1. Codigo1}, ..., {SimbN,
% CodigoN} em ordem de tamanho do codigo
cabecalho = [];
for n = 1:length(SimbCodigos)
    tempStr = [SimbCodigos(n).Simbolo, ', ' SimbCodigos(n).Codigo];
    if n < length(SimbCodigos)
       tempStr = [tempStr '`|'];
    end    
    cabecalho = [cabecalho tempStr];
end

n = length(bitstream);
%Calcula o n�mero de bytes a escrever.
n8 = ceil(n/8);

%Concatena zeros para completar um m�ltiplo de 8.
bitstream = [bitstream dec2bin(0,n8*8 - n)];

%Transforma o bitstream que est� em bits para um array de uint8.
bitstream2 = zeros(ceil(n/8),1);
for (i = 1:1:length(bitstream2))
    bitstream2(i) = bin2dec(bitstream((i-1)*8 + 1: i*8));    
end

%% Escrevendo no arquivo
%strArquivo = [cabecalho bitstream];
fp = fopen(nomeArquivo, 'wb');
tamanhoCabecalho = length(cabecalho);
tamanhoCabecalho % imprime o tamanho do header
fwrite(fp, n, 'uint32');
fwrite(fp, h, 'uint16'); % altura da imagem
fwrite(fp, w, 'uint16'); % largura da imagem
fwrite(fp, alpha, 'double');
fwrite(fp, tamanhoCabecalho, 'uint16');
fwrite(fp, cabecalho, 'uint8');
fwrite(fp, bitstream2, 'uint8');
fclose(fp);

end

