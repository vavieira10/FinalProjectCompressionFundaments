function [R,G,B] = yuv2rgb(Y,U,V)
%YUV2RGB - Converte imagens no formato YUV para o formato RGB.
%   [R,G,B] = yuv2rgb(Y,U,V) converte a imagem (ou video) descrito pelos
%   parametros Y, U e V para o padrao RGB e retorna nas variaveis R,G e B. 
%   
%   [R,G,B] = yuv2rgb(Y) converte a imagem (ou video) de luminancia Y para
%   o formato RGB.
%
%   yuv2rgb(Y,U,V) converte e mostra a imagem (ou primeiro frame) descrito
%   pelos parametros Y, U e V.
%
%   A matriz de transformacao utilizada e a recomendada pelo ITU:
%   R = Y + 0.0000*(U-128) + 1.4020*(V-128)
%   G = Y - 0.3441*(U-128) - 0.7139*(V-128)
%   B = Y + 1.7718*(U-128) + 0.0012*(V-128)
%
%   Se as matrizes U e V tiverem um quarto da resolucao de Y, o programa
%   automaticamente interpola U e V utilizando interpolacao bicubica.
%
%   Eduardo Peixoto F. Silva.
%   eduardopfs@gmail.com
%   Edson Mintsu Hung
%   mintsu@gmail.com

%Numero de Parametros = 0.
if nargin == 0
    disp('Numero de argumentos insuficiente.')
    disp('A funcao yuv2rgb precisa de 1 ou 3 argumentos.')
    return
end

%Numero de Parametros = 1.
if nargin == 1
    [wy hy ny] = size(Y);
    luma_only = 1;
    U = zeros(size(Y));
    V = zeros(size(Y));
end

%Numero de Parametros = 2.
if nargin == 2
    disp('Numero de argumentos insuficiente.')
    disp('A funcao yuv2rgb precisa de 1 ou 3 argumentos.')
    return
end

%Numero de Parametros = 3.
if nargin == 3
    [wy hy ny] = size(Y);
    [wu hu nu] = size(U);
    [wv hv nv] = size(V);
    
    luma_only = 0;
    
    if (ny ~= nu | ny ~= nv | nu ~= nv)
        disp('As matrizes de entrada nao tem o mensmo numero de frames.')
        return
    end
    
    if (hu ~= hv | wu ~= wv)
        disp('As matrizes de crominancia nao tem o mesmo temanho.')
        return
    end
        
    %Faz o upsampling se for preciso.
    if (((wy/wu) == 2) & ((hy/hu) == 2))
        
        u = zeros(size(Y));
        v = zeros(size(Y));
        for (n = 1:ny)
            u(:,:,n) = imresize(U(:,:,n),2,'bicubic');
            v(:,:,n) = imresize(V(:,:,n),2,'bicubic');            
        end
        clear U V;
        U = u;
        V = v;
        clear u v;
        
    end
    if ( (((wy == wu) & (hy == hu)) | ((wy == 2*wu) & (hy == 2*hu))) == 0 )
        disp('A razao entre os frames de luminancia e de crominancia nao e 1 ou 2.')
        return
    end
    
end

%Corpo da funcao.
R = zeros(size(Y));
G = zeros(size(Y));
B = zeros(size(Y));

Y = double(Y);
U = double(U);
V = double(V);

%Faz a transformacao segundo a recomendacao do ITU.
if (luma_only == 0)
    U = U - 128;
    V = V - 128;
end
R = Y + 0.0000 * U + 1.4020 * V;
G = Y - 0.3441 * U - 0.7139 * V;
B = Y + 1.7718 * U + 0.0012 * V;

%Faz o threshold.
R(R<0) = 0;
R(R>255) = 255;
G(G<0) = 0;
G(G>255) = 255;
B(B<0) = 0;
B(B>255) = 255;

R = uint8(R);
G = uint8(G);
B = uint8(B);

if nargout == 0    
    imagem(:,:,1) = R(:,:,1);
    imagem(:,:,2) = G(:,:,1);
    imagem(:,:,3) = B(:,:,1);
    figure;
    imshow(imagem);
end
