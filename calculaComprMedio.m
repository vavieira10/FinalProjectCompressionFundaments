function [comprMedio] = calculaComprMedio(vetorProbs, codigos)
% Funcao que vai receber o vetor de structs que corresponde a tabela de
% codigos de cada simbolo e o vetor de structs com as probabilidades de uma 
% fonte e vai retornar o comprimento medio dessa codificacao

%% Inicializacao de variaveis
comprMedio = 0;

%% Calculo do comprimento medio
for i = 1:length(codigos)
   comprMedio = comprMedio + vetorProbs(i).Probabilidade*length(codigos(i).Codigo);  
end

end

