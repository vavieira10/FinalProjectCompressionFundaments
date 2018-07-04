function [vetorStructsOrd] = ordenaStructs(vetorStructs)
% Funcao que recebe um vetor de structs, aonde cada struct contem o simbolo
% e a probabilidade do simbolo para determianda fonte e retorna esse vetor
% de structs ordenado em funcao das probabilidades

% OBS: CODIGO ADAPTADO DO FORUM DO MATLAB, LINK ABAIXO
% https://www.mathworks.com/matlabcentral/answers/97965-how-can-i-sort-an-array-of-structures-based-upon-a-particular-field-in-matlab
if ( ~isempty(vetorStructs) &&  length(vetorStructs) > 0)
      [~,I] = sort(arrayfun (@(x) x.Probabilidade, vetorStructs), 'descend') ;
      vetorStructsOrd = vetorStructs(I) ;        
    else 
        disp ('Vetor de structs vazio!');
    end      

end