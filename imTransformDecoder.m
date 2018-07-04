function decodedImage = ciqaDecoder(inputFile, alpha)

% O passo de quantizacao usado eh padrao, e vai utilizar a matriz padrao do
% JPEG
quantizationMatrix = [16 11 10 16 24 40 51 61;
                      12 12 14 19 26 58 60 55;
                      14 13 16 24 40 57 69 56;
                      14 17 22 29 51 87 80 62;
                      18 22 37 56 68 109 103 77;
                      24 35 55 64 81 104 113 92;
                      49 64 78 87 103 121 120 101;
                      72 92 95 98 112 100 103 99];

%Abre o arquivo
fid = fopen(inputFile,'rb');

%L� o n�mero de bits escrito.
N = fread(fid, 1, 'uint16');
M = fread(fid, 1, 'uint16');
h = fread(fid, 1, 'uint16');
w = fread(fid, 1, 'uint16');
amountBlocks = (h*w)/(N*N);

%Calcula o n�mero de bytes escrito para cada bloco.
szBitstream = N*N*log2(M);
n8 = ceil(szBitstream/8);

%L� todos os bytes.
szIndex = log2(M);
decodedBlocks = zeros(N*N, amountBlocks);
for i = 1:amountBlocks
    minBlock = fread(fid, 1, 'uint8');
    maxBlock = fread(fid, 1, 'uint8');
    delta = (maxBlock - minBlock)/M;
    x = [double(minBlock):delta:double(maxBlock)];
    k = floor(0.5 + x(1:M)./delta);
    yk = delta.*k; % valores de reconstrucao
    yk = floor(yk);
    bitstream2 = fread(fid, n8, 'uint8');
    %Converte os bytes em um array de bits.
    bitstream = zeros(n8 * 8, 1);
    for j = 1:1:n8
        bitstream((j-1)*8 + 1: j*8) = dec2bin(bitstream2(j),8);
    end
    %Remove os bits excedentes.
    bitstream = char(bitstream(1:szBitstream)');
    counter = 1;
    for b = 1:szIndex:szBitstream
        idxYk = bin2dec(bitstream(b:((b-1) + szIndex))) + 1;
        decodedBlocks(counter, i) = yk(idxYk);
        counter = counter + 1;
    end
    
end


%Fecha o arquivo.
fclose(fid);
decodedImage = zeros(h, w);
counter = 1;
for i = 1:N:w
    for j = 1:N:h
        decodedImage(i:(i + N - 1), j:(j + N - 1)) = vec2mat(decodedBlocks(:, counter), N)';
        counter = counter + 1;
    end 
end

decodedImage = uint8(decodedImage);

end

