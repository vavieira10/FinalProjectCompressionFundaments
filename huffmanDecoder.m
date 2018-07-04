function seqOriginal = huffmanDecoder(bitstream, alfabeto, codigos, tipoArq)
% Funcao que implementa a decodificacao do bitstream por meio do alfabeto e
% codigos que foram obtidos no cabecalho do arquivo comprimido

% Retorna a sequencia original que foi comprimida


%% Inicializacao das variaveis
seqOriginal = [];
bitstreamTemp = [];% vai ser usado para armazenar o bitstream temporario 
n = length(bitstream);

%% Gerando a sequencia do arquivo original
debug = 0;
for i = 1:n
   bitstreamTemp = [bitstreamTemp bitstream(i)];
   indice = procuraCodigo(bitstreamTemp, codigos);
   if(length(seqOriginal) == 500)
      debug = 1; 
   end
   if(indice == 0)
       continue; % continua o loop
   else
       % se tipoArq for 1, alfabeto eh char, senao eh inteiro
       if(tipoArq == 1)
           seqOriginal = [seqOriginal alfabeto{1, indice}{1, 1}];
       else
           seqOriginal = [seqOriginal alfabeto{1, indice}];
       end
       bitstreamTemp = [];
   end
   
end

seqOriginal = seqOriginal';

end

% Funcao auxiliar que vai ser utilizada pelo decodificador
function indice = procuraCodigo(seqBits, codigos)
% Funcao que recebe uma sequencia de bits e os codigos dos simbolos da
% fonte e retorna o indice do vetor de codigos que teve um match com a
% sequencia de bits

% Se a sequencia de bits nao tiver sido encontrada, o indice retornado eh 0

n = length(codigos);

indice = 0; 
for i=1:n
   if(strcmp(seqBits, codigos{1, i}{1, 1}))
      indice = i; 
   end
end

end
