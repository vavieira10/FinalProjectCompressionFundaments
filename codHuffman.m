function [arvCodHuffman, codigos] = codHuffman(vetorStructsOrd)
% Funcao que implementa o codigo de huffman. Recebe um vetor de structs ordenado 
% pelas probabilidades e retorna a arvore do codigo de huffman construida

%% Inicializacao de variaveis e structs
% Cada no da arvore do codigo huffman vai ter 5 atributos
noArvore = struct('Esq',[],...
                  'Dir',[],...,
                  'noRaiz',[],...
                  'noFolha',0,... % se for 1 eh folha, se 0 nao eh
                  'Simbolo',[],...
                  'Probabilidade',[]); 
vetStructsNosArvore = struct('Esq',{},...
                             'Dir',{},...
                             'noRaiz',[],...
                             'noFolha',0,...
                             'Simbolo',[],...
                             'Probabilidade',[]); 
nSimbolos = length(vetorStructsOrd);
              
%% Codigo de Huffman

% Gerando o array de nos de arvore, que contem cada simbolo e sua
% respectiva probabilidade (array ja esta com as structs ordenadas)
for n = 1:nSimbolos
    noArvore.Simbolo = vetorStructsOrd(n).Simbolo;
    noArvore.Probabilidade = vetorStructsOrd(n).Probabilidade;
    noArvore.noFolha = 1; % inicialmente todos as sub arvores arvore sao folhas
    noArvore.noRaiz = 0; % inicialmente todos as sub arvores nao sao raizes
    vetStructsNosArvore(n) = noArvore;
end

% reinicializa as variaveis da struct noArvore
noArvore.Simbolo = -1;
noArvore.Probabilidade = 0;
noArvore.noFolha = 0;

nNoArvores = nSimbolos;
menor = 0; % sub arvore com menor probabilidade
segMenor = 0; % sub arvore com a segunda menor probabilidade

% Loop que implementa o codigo de huffman
% ideia eh construir a arvore de codificacao diretamente
% na medida que le o vetor de sub arvores, vai construindo a arvore
% seguindo o algoritmo de huffman, ou seja, juntando os nos com menor
% probabilidade
while nNoArvores > 1
    menor = nNoArvores;
    segMenor = nNoArvores - 1;
    noTemp = vetStructsNosArvore(menor);
    
    % o novo menor simbolo (no da arvore) que esta sendo criado eh a uniao
    % dos dois menores
    vetStructsNosArvore(menor) = noArvore; % reinicializa o menor no da arvore
    vetStructsNosArvore(menor).Probabilidade = noTemp.Probabilidade + vetStructsNosArvore(segMenor).Probabilidade;
    % -1 eh o simbolo para os nos da arvore que nao sao folha e que nao correspondem a nenhum simbolo 
    vetStructsNosArvore(menor).Esq = vetStructsNosArvore(segMenor);
    vetStructsNosArvore(menor).Dir = noTemp;
    
    % remove o segundo elemento com menor probabilidade do vetor de sub arvores
    vetStructsNosArvore = removeElementoVetor(segMenor, vetStructsNosArvore);
    % ordena o novo vetor de sub arvores por probabilidade
    vetStructsNosArvore = ordenaStructs(vetStructsNosArvore);
    nNoArvores = nNoArvores - 1;
end

arvCodHuffman = vetStructsNosArvore;
arvCodHuffman.noRaiz = 1;

codigos = struct('Simbolo', {}, 'Codigo', {});
codigosNosIntermed = []; % variavel que vai virar string dos codigos de quando o no que esta sendo lido nao eh folha
codigos = geraCodigos(arvCodHuffman, '0', codigos, codigosNosIntermed);

%% Ordenando os simbolos pelo tamanho das palavras codigo
[~,I] = sort(arrayfun (@(x) length(x.Codigo), codigos), 'ascend') ;
codigos = codigos(I);

end

% Funcao que vai remover o elemento x do vetor passado como argumento e
% vai retornar o novo vetor
function [vetorSaida] = removeElementoVetor(elemento, vetorEntrada)
    vetorSaida = vetorEntrada([1:elemento - 1, elemento + 1:end]);
end

% Funcao recursiva que recebe a arvore de huffman e percorre a arvore para retornar um vetor de structs
% aonde cada struct corresponde ao simbolo e seu codigo
function [codigos] = geraCodigos(arvoreHuffman, codigo, codigosTemp, codigosNaoFolhas)
% se nao for raiz e nem no folha, concatena o char codigo na string
% codigosNaoFolhas que correspondem aos codigos dos nos intermediarios
if(arvoreHuffman.noRaiz ~= 1 && arvoreHuffman.noFolha ~= 1)
   codigosNaoFolhas = [codigosNaoFolhas codigo];
end

if(arvoreHuffman.noFolha == 1)
    x.Simbolo = arvoreHuffman.Simbolo;
    x.Codigo = [codigosNaoFolhas codigo];
    codigosTemp(end + 1) = x;
    codigosNaoFolhas = []; % sempre que um simbolo for codificado, reinicializa a variavel
else
    % Como a funcao eh recursiva, ela eh feita para cada sub arvore a
    % esquerda e a direita da atual
    codigosTemp = geraCodigos(arvoreHuffman.Esq, '0', codigosTemp, codigosNaoFolhas);
    codigosTemp = geraCodigos(arvoreHuffman.Dir, '1', codigosTemp, codigosNaoFolhas);
    
end

codigos = codigosTemp;

end

