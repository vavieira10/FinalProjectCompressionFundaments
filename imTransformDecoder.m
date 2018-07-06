function decodedImage = imTransformDecoder(codedBlocks, h, w, alpha, N)
%Funcao que vai implementar a etapa de decodificacao do decodificador de
%imagens por transformada
% Funcao recebe uma imagem, o nome do arquivo binario a ser codificado, um
% parametro para ser usado na matriz de quantizacao e o tamanho do bloco a
% ser usado
% Retorna a imagem decodificada

quantizationMatrix = alpha*[16 11 10 16 24 40 51 61;
                      12 12 14 19 26 58 60 55;
                      14 13 16 24 40 57 69 56;
                      14 17 22 29 51 87 80 62;
                      18 22 37 56 68 109 103 77;
                      24 35 55 64 81 104 113 92;
                      49 64 78 87 103 121 120 101;
                      72 92 95 98 112 100 103 99];


%L� o n�mero de bits escrito.
amountBlocks = (h*w)/(N*N);

%Calcula o n�mero de bytes escrito para cada bloco.

decodedBlocks = zeros(N*N, amountBlocks);
block = zeros(N, N);
%% Parte que vai pegar o vetor de structs que correspondem a cada bloco e vai decodificar os blocos e prepara-los para gerar a imagem decodificada
for i= 1:length(codedBlocks)
    if(codedBlocks(i).countOfZeros ~= 64)
        runlengthArray = codedBlocks(i).runLengthArray; % run length vector
    else
        runlengthArray = [];
    end
    zerosArray = zeros(codedBlocks(i).countOfZeros, 1); % criando um vetor de 0s que vai ser concatenado com o run length array
    decodedBlocks(:, i) = [runlengthArray; zerosArray];
    block = invzigzag(decodedBlocks(:, i)); % using the inverse zigzag
    desquantizedBlock = block.*quantizationMatrix; % desquantizar o bloco
    inverseDctBlock = idct2(desquantizedBlock); % inversa dct do bloco
    decodedBlock = inverseDctBlock + 128; % somar de volta o 128 que foi usado para deslocar os componentes DC
    decodedBlocks(:, i) = decodedBlock(:);
end


decodedBlocks = round(decodedBlocks);
%Fecha o arquivo.
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

