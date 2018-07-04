function bitstream = huffmanEncoder(simbolosECodigos, seqArquivo)
% Funcao que implementa a construcao do bitstream por meio do alfabeto do
% arquivo, dos codigos gerados para cada simbolo e da sequencia do arquivo

% Retorna o bitstream que vai ser escrito no arquivo comprimido

%% Inicializa e gera as variaveis que armazenam o alfabeto e os simbolos
alfabeto = [];
codigos = {};
for i = 1:length(simbolosECodigos)
    alfabeto(i) = simbolosECodigos(i).Simbolo;
end

for i = 1:length(simbolosECodigos)
    codigos{i} = simbolosECodigos(i).Codigo;
end

%% Gerando o bitstream
n = length(seqArquivo);
bitstream = [];

%Para todos os elementos da mensagem.
for (i = 1:1:n)
    %Encontra o index do elemento atual (msg(i)) no codigo.
    idx = (seqArquivo(i) == alfabeto);
    
    %Anexa ao bitstream o codigo binario referente ao elemento atual.
    bitstream = [bitstream codigos{idx}];
end

end

