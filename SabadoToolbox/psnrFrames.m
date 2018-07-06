function psnrFrames(file1,file2,nframes)
% PSNRFRAMES - Calcula a psnr frame a frame entre dois arquivos de video
%  YUV.
%
%    psnrFrames('file1','file2',nframes) calcula a psnr entre os primeiros nframes frames
%    de luminancia dos arquivos 'file1' e 'file2', alem de mostrar a psnr
%    global e a psnr global retirando o pior, os 2 piores e os 3 piores
%    frames.
%
%    Veja tambem: PSNR.
%
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com

Y1 = readyuv(file1,352,288,nframes);
Y2 = readyuv(file2,352,288,nframes);

[h w nframes] = size(Y1);

psnrFrames = zeros(nframes,1);

%Calculo a PSNR e acho o frame que tem a menor PSNR.
minPSNR = Inf;
posMinPSNR = 0;
for (n = 1:1:nframes)
    psnrFrames(n) = psnr(Y1(:,:,n),Y2(:,:,n));
    if (psnrFrames(n) < minPSNR)
        minPSNR = psnrFrames(n);
        posMinPSNR = n;
    end
end

%Mostro a PSNR de todos os frames.
disp('======================================================')
for (n = 1:1:nframes)
    disp(['PSNR do Frame ' num2str(n) ' : ' num2str(psnrFrames(n)) ' dB.'])   
end

%Retiro o frame que tem a menor psnr.
Y11 = zeros(h,w,nframes - 1);
Y21 = zeros(h,w,nframes - 1);

for (n = 1:1:nframes)
    if (n ~= posMinPSNR)
        Y11(:,:,n) = Y1(:,:,n);
        Y21(:,:,n) = Y2(:,:,n);
    end
end

nframes = nframes - 1;
%Calculo a PSNR e acho o frame que tem a menor PSNR.
minPSNR = Inf;
posMinPSNR = 0;
for (n = 1:1:nframes)    
    if (psnr(Y11(:,:,n),Y21(:,:,n)) < minPSNR)
        minPSNR = psnr(Y11(:,:,n),Y21(:,:,n));
        posMinPSNR = n;
    end
end


%Retiro o frame que tem a menor psnr.
Y12 = zeros(h,w,nframes - 1);
Y22 = zeros(h,w,nframes - 1);

for (n = 1:1:nframes)
    if (n ~= posMinPSNR)
        Y12(:,:,n) = Y11(:,:,n);
        Y22(:,:,n) = Y21(:,:,n);
    end
end

nframes = nframes - 1;
%Calculo a PSNR e acho o frame que tem a menor PSNR.
minPSNR = Inf;
posMinPSNR = 0;
for (n = 1:1:nframes)    
    if (psnr(Y12(:,:,n),Y22(:,:,n)) < minPSNR)
        minPSNR = psnr(Y12(:,:,n),Y22(:,:,n));
        posMinPSNR = n;
    end
end


%Retiro o frame que tem a menor psnr.
Y13 = zeros(h,w,nframes - 1);
Y23 = zeros(h,w,nframes - 1);

for (n = 1:1:nframes)
    if (n ~= posMinPSNR)
        Y13(:,:,n) = Y12(:,:,n);
        Y23(:,:,n) = Y22(:,:,n);
    end
end

nframes = nframes - 1;
%Calculo a PSNR e acho o frame que tem a menor PSNR.
minPSNR = Inf;
posMinPSNR = 0;
for (n = 1:1:nframes)    
    if (psnr(Y13(:,:,n),Y23(:,:,n)) < minPSNR)
        minPSNR = psnr(Y13(:,:,n),Y23(:,:,n));
        posMinPSNR = n;
    end
end

disp('======================================================')
disp(['PSNR              : ' num2str(psnr(Y1,Y2)) ' dB.'])
disp(['PSNR -1 Pior Frame: ' num2str(psnr(Y11,Y21)) ' dB.'])
disp(['PSNR -2 Pior Frame: ' num2str(psnr(Y12,Y22)) ' dB.'])
disp(['PSNR -3 Pior Frame: ' num2str(psnr(Y13,Y23)) ' dB.'])
disp('======================================================')




