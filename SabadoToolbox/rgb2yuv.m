function [Y,U,V] = rgb2yuv(R,G,B,downsample)
%RGB2YUV - Converte imagens no formato RGB para o formato YUV.
%   [Y,U,V] = rgb2yuv(R,G,B) converte a imagem (ou video) descrito pelos
%   parametros R, G e B para o padrao YUV e retorna nas variaveis Y,U e V. 
%   
%   [Y,U,V] = rgb2yuv(R,G,B,downsample) converte a imagem (ou video)
%   descrito pelos parametros R, G e B para o padrao YUV 420, reduzindo a
%   resolucao dos frames de crominancia.
%
%   rgb2yuv(R,G,B) converte e mostra a imagem (ou primeiro frame) descrito
%   pelos parametros R, G e b.
%
%   A matriz de transformacao utilizada e a recomendada pelo ITU:
%   Y = 0.2990 * R + 0.5870 * G + 0.1140 * B;
%   U = -0.1684 * R - 0.3316 * G + 0.5000 * B + 128;
%   V = 0.5000 * R - 0.4187 * G - 0.0813 * B + 128;
%
%   Eduardo Peixoto F. Silva.
%   eduardopfs@gmail.com
%   Edson Mintsu Hung
%   mintsu@gmail.com


%Numero de Parametros = 0.
if nargin < 3
    disp('Numero de argumentos insuficiente.')
    disp('A funcao yuv2rgb precisa de 3 argumentos.')
    return
end

%Numero de Parametros = 3.
if nargin == 3
    [wr hr nr] = size(R);
    [wg hg ng] = size(G);
    [wb hb nb] = size(B);
    
    if (nr ~= ng | nr ~= nb | ng ~= nb)
        disp('As matrizes de entrada nao tem o mensmo numero de frames.')
        return
    end
    
    if (wr ~= wg | wr ~= wb | wg ~= wb | hr ~= hg | hr ~= hb | hg ~= hb)
        disp('As matrizes de entrada nao tem as mesmas dimensoes.')
        return
    end
    
    downsample = 0;
end

%Numero de Parametros = 4.
if nargin == 4
    [wr hr nr] = size(R);
    [wg hg ng] = size(G);
    [wb hb nb] = size(B);
    
    if (nr ~= ng | nr ~= nb | ng ~= nb)
        disp('As matrizes de entrada nao tem o mensmo numero de frames.')
        return
    end
    
    if (wr ~= wg | wr ~= wb | wg ~= wb | hr ~= hg | hr ~= hb | hg ~= hb)
        disp('As matrizes de entrada nao tem as mesmas dimensoes.')
        return
    end
    
    if (downsample ~= 0)
        downsample = 1;
    end
end

%Corpo da funcao.
Y = zeros(size(R));
U = zeros(size(R));
V = zeros(size(R));

R = double(R);
G = double(G);
B = double(B);

%Faz a transformacao segundo a recomendacao do ITU.
Y = 0.2990 * R + 0.5870 * G + 0.1140 * B;
U = -0.1684 * R - 0.3316 * G + 0.5000 * B + 128;
V = 0.5000 * R - 0.4187 * G - 0.0813 * B + 128;

%Faz o downsample, se necessario.
if (downsample == 1)
    u = zeros(wr/2,hr/2,nr);
    v = zeros(wr/2,hr/2,nr);

    for (i = 1:nr)
        u(:,:,i) = imresize(U(:,:,i),0.5);%,'bicubic',16);
        v(:,:,i) = imresize(V(:,:,i),0.5);%,'bicubic',16);
    end
    clear U V;
    U = u;
    V = v;
    clear u v;
end


%Faz o threshold.
Y(Y<0) = 0;
Y(Y>255) = 255;
U(U<0) = 0;
U(U>255) = 255;
V(V<0) = 0;
V(V>255) = 255;

Y = uint8(Y);
U = uint8(U);
V = uint8(V);

if nargout == 0    
    yuv2rgb(Y,U,V);
end
