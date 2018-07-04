function [entropia] = calculaEntropia(vetorStructs)
% Funcao que vai receber o vetor de structs que corresponde a tabela de
% probabilidades de cada simbolo de uma fonte e vai retornar a entropia 
% dessa fonte

%% Inicializacao de variaveis
entropia = 0;

%% Calculo da entropia
for i = 1:length(vetorStructs)
   entropia = entropia - vetorStructs(i).Probabilidade*log2(vetorStructs(i).Probabilidade);  
end

end

