function [outputArray, countOfZeros] = runLengthCoding(inputArray)
% Funcao que implementa run length coding, ou seja, calcula a quantidade
% de vezes que o elemento 0 acontece no final de um vetor e os retira

%% Inicializacao das variaveis a serem usadas
countOfZeros = 0;
szInpArray = length(inputArray);

%% Run length coding
% Enquanto nao for 0, incrementa o contador
for i = szInpArray:-1:1
    if(inputArray(i) ~= 0)
        break;
    end
    countOfZeros = countOfZeros + 1;    
end

outputArray = inputArray(1:(szInpArray - countOfZeros));

end

