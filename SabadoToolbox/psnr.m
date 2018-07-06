function [globalPSNR,psnrY,psnrU,psnrV] = psnr(param1,param2,param3,param4,param5,param6,param7)
%PSNR - Peak-Signal to Noise Ratio
%    [psnrGlobal, psnrY,psnrU,psnrV] = psnr(Y1,U1,V1,Y2,U2,V2,bitdepth)
%
%    psnr(Y1,Y2) calculates the global and average PSNRs between the two
%    sequences and display the results on the screen. The bitdetph is taken
%    from the maximum value of the 2 matrices.
%
%    globalPSNR = psnr(Y1,Y2) calculates the global PSNR among all frames
%    of the two sequences.
%
%    [globalPSNR,psnrY] = psnr(Y1,Y2) calculates the global PSNR among all 
%    frames of the two sequences, and also returns an array with the PSNR
%    of each frame in the sequence (of size nframes x 1).
%
%    [globalPSNR,psnrY] = psnr(Y1,Y2,bitdepth) calculates the global PSNR 
%    among all frames of the two sequences, and also returns an array with 
%    the PSNR of each frame in the sequence (of size nframes x 1), using 
%    the specified bitdepth.
%
%    [globalPSNR] = psnr(Y1,U1,V1,Y2,U2,V2) calculates the global PSNR 
%    among all frames of the YUV components of the two sequences.
%
%    [globalPSNR,psnrY,psnrU,psnrV] = psnr(Y1,U1,V1,Y2,U2,V2) calculates 
%    the global PSNR among all frames of the YUV components of the two 
%    sequences, and also returns three arrays with the PSNR of each frame 
%    of each component (each one of size nframes x 1).
%
%    [globalPSNR,psnrY,psnrU,psnrV] = psnr(Y1,U1,V1,Y2,U2,V2,bitdepth) 
%    calculates the global PSNR among all frames of the YUV components of 
%    the two sequences, and also returns three arrays with the PSNR of each
%    frame of each component (each one of size nframes x 1), using the 
%    specified bitdepth.
%
%    psnr = 10 * log10 ( (2^nBits - 1) / MSE)
%    MSE = (1/N) * sum(i:N) (x(i) - y(i)).^2
%
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com
%

%%%%%%%%%%%%%%%%%%%%%%%%%
%Checks the number of parameters.
if ((nargin == 2) && (nargout <= 2))
    Y1 = param1;
    Y2 = param2;
    bitdepth = 0;
    consider_chroma = 0;
elseif ((nargin == 3) && (nargout <= 2))
    Y1 = param1;
    Y2 = param2;
    bitdepth = param3;
    consider_chroma = 0;
elseif ((nargin == 6) && ((nargout < 2) || (nargout == 4)))
    Y1 = param1;
    U1 = param2;
    V1 = param3;
    Y2 = param4;
    U2 = param5;
    V2 = param6;
    bitdepth = 0;
    consider_chroma = 1;
elseif ((nargin == 7) && ((nargout < 2) || (nargout == 4)))
    Y1 = param1;
    U1 = param2;
    V1 = param3;
    Y2 = param4;
    U2 = param5;
    V2 = param6;
    bitdepth = param7;
    consider_chroma = 1;
else
    error('Incorrect number of input / output parameters. Type help psnr for help.')    
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Check the size of the sequences.
[wy1 hy1 ny1] = size(Y1);
[wy2 hy2 ny2] = size(Y2);

if ((wy1 ~= wy2) || (hy1 ~= hy2) || (ny1 ~= ny2))
    error('The size of the sequences must be the same.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Checks the sizes of the chrominance components
if (consider_chroma == 1)
    [wu1 hu1 nu1] = size(U1);
    [wu2 hu2 nu2] = size(U2);
    
    [wv1 hv1 nv1] = size(V1);
    [wv2 hv2 nv2] = size(V2);
        
    if ((wu1 ~= wu2) || (hu1 ~= hu2) || (nu1 ~= nu2))
        error('The size of the sequences must be the same.')
    end
    
    if ((wv1 ~= wv2) || (hv1 ~= hv2) || (nv1 ~= nv2))
        error('The size of the sequences must be the same.')
    end
    
    if ((wu1 ~= wv1) || (hu1 ~= hv1) || (nu1 ~= nv1))
        error('The size of the sequences must be the same.')
    end    
    
    if (ny1 ~= nu1)
        error('The size of the sequences must be the same.')
    end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Changes the datatype according to the bitdepth.
if (bitdepth == 0) %If the bitdepth is 0, it will guess the bitdepth according to the data.
    maxY1 = max(max(max(Y1)));
    maxY2 = max(max(max(Y2)));
    
    if (maxY1 > maxY2)
        max_value = maxY1;
    else
        max_value = maxY2;
    end
    
    if (consider_chroma == 1)
        maxU1 = max(max(max(U1)));
        maxV1 = max(max(max(V1)));
        maxU2 = max(max(max(U2)));
        maxV2 = max(max(max(V2)));
        
        if (max_value < maxU1)
            max_value = maxU1;            
        end
        if (max_value < maxV1)
            max_value = maxV1;
        end
        if (max_value < maxU2)
            max_value = maxU2;            
        end
        if (max_value < maxV2)
            max_value = maxV2;
        end
    end
    
    n = ceil(log2(double(max_value)));
    
    if (n < 8)
        bitdepth = 8;
    else
        bitdepth = n;
    end
end

%Gets the actual size of the matrices.
nframes = ny1;
w_luma = wy1;
h_luma = hy1;
if (consider_chroma == 1)
    w_chroma = wu1;
    h_chroma = hu1;    
end

%Computes the peak value.
peak_value = 2^bitdepth - 1;

%Computes the square difference.
squareDiffY = computeSquareDiff(Y1,Y2,nframes);
if (consider_chroma == 1)
    squareDiffU = computeSquareDiff(U1,U2,nframes);
    squareDiffV = computeSquareDiff(V1,V2,nframes);
end

%Disable the matlab warning.
warning off MATLAB:divideByZero

%Computes the PSNR for every frame.
if (consider_chroma == 0)
    %Computes the average PSNR.
    psnrY = 10 * log10 ( (peak_value^2) ./ (squareDiffY./(w_luma*h_luma)));
    averagePSNR = sum(psnrY)/nframes;
    
    %Computes the global PSNR.
    globalPSNR = 10 * log10 ( (peak_value^2) ./ (sum(squareDiffY)/(w_luma*h_luma*nframes)));
else
    %Computes the average PSNR.
    psnrY = 10 * log10 ( (peak_value^2) ./ (squareDiffY./(w_luma*h_luma)));
    averagePSNR_Y = sum(psnrY)/nframes;
    psnrU = 10 * log10 ( (peak_value^2) ./ (squareDiffU./(w_chroma*h_chroma)));
    averagePSNR_U = sum(psnrU)/nframes;
    psnrV = 10 * log10 ( (peak_value^2) ./ (squareDiffV./(w_chroma*h_chroma)));
    averagePSNR_V = sum(psnrV)/nframes;
    
    %Computes the global PSNR.
    squareDiff = sum(squareDiffY) + sum(squareDiffU) + sum(squareDiffV);
    mse = squareDiff / ((w_luma*h_luma*nframes) + (w_chroma*h_chroma*nframes) + (w_chroma*h_chroma*nframes));
    globalPSNR = 10 * log10 ( (peak_value^2) / mse);        
end

%If no argument has been specified, it shows the global and average PSNRs
%on the screen
if (nargout == 0)
    if (consider_chroma == 0)
        disp(['Global PSNR  = ' num2str(globalPSNR) ' dB.'])    
        disp(['Average PSNR = ' num2str(averagePSNR) ' dB.'])    
    else
        disp(['Global PSNR    = ' num2str(globalPSNR) ' dB.'])    
        disp(['Average PSNR Y = ' num2str(averagePSNR_Y) ' dB.']) 
        disp(['Average PSNR U = ' num2str(averagePSNR_U) ' dB.']) 
        disp(['Average PSNR V = ' num2str(averagePSNR_V) ' dB.']) 
    end
end


%Subfunction 1 - computes the squared of the difference for all frames.
function squareDiff = computeSquareDiff(video1,video2,n)

%Changes the video to double.
video1 = double(video1);
video2 = double(video2);

squareDiff = zeros(n,1);
for (i = 1:1:n)
    squareDiff(i,1) = sum(sum( (video1(:,:,i) - video2(:,:,i)).^2 ) );    
end