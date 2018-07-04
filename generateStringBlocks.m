function outputString = generateStringBlocks(codedBlocksStruct)
% Recebe o vetor de structs de cada bloco codificado e retorna uma string
% aonde cada linha corresponde a um bloco

outputString = '';

for i = 1:length(codedBlocksStruct)
   % char(10) corresponde ao caracter \n, ou seja, new line 
   outputString = [outputString num2str(codedBlocksStruct(i).countOfZeros) ' ' ...
                    num2str(codedBlocksStruct(i).runLengthArray') char(10)]; 
end

end

