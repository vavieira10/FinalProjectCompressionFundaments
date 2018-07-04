function vetorStructs = structGenerator(stringCodedBlocks)
%   Funcao que recebe uma string de entrada e verifica quais os simbolos
%   presentes, calcula a probabilidade de cada um dos simbolos e retorna um
%   vetor de structs, aonde cada struct vai conter o simbolo e sua
%   probabilidade

%% Inicializacao das variaveis e leitura do arquivo
vetorStructs = struct('Simbolo',{},...
                  'Probabilidade',{});
              
%%%%%%%CODIGO ILUSTRADO EM SALA DE AULA PELO PROFESSOR EDUARDO %%%%%%%
numTotalSimbFonte = length(stringCodedBlocks);


%% Calculo da frequencia e da probabilidade de cada um dos simbolos
simbolosFonte = unique(stringCodedBlocks);
simbolosFonte = simbolosFonte';
numeroSimbolos = size(simbolosFonte, 1);
vetorProbabilidades = zeros(numeroSimbolos, 1);
frequencia = zeros(numeroSimbolos, 1);

for i = 1:numeroSimbolos
    frequencia(i) = sum(stringCodedBlocks == simbolosFonte(i));
end

%%%%%%%%%%%%%%%FIM DO CODIGO ILUSTRADO PELO PROFESSOR EDUARDO %%%%%%%%%

vetorProbabilidades(1:numeroSimbolos) = frequencia(1:numeroSimbolos)/numTotalSimbFonte;

%% Gerando o vetor de structs
for i = 1:numeroSimbolos
   x.Simbolo = simbolosFonte(i);
   x.Probabilidade = vetorProbabilidades(i);
   vetorStructs(end + 1) = x;
end

% Ordena o vetor de structs pela probabilidade
vetorStructs = ordenaStructs(vetorStructs);

end

