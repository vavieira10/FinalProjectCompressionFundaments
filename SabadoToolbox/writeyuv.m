function writeyuv(filename,Y,param3,param4,param5,param6)
%WRITEYUV - Writes video files in format YUV (raw).
%    writeyuv(filename,Y) writes the luminance component Y in the file
%    filename. The chrominance components are considered to be a quarter 
%    the size of the luminance component, and are filled with 0 and the
%    bitdepth used is taken from the Y matrix.
%
%    writeyuv(filename,Y,bitdepth) writes the luminance component Y in the 
%    file filename. The chrominance components are filled with 0 and it 
%    uses the bitdepth specified. However, it DOES NOT convert the file 
%    (so, if the Y matrix has a maximum value of 255, and it is written 
%    with bitdepth 10, the maximum value will still be 255, not 1023).
%   
%    writeyuv(filename,Y,U,V) writes the Y, U and V components in the file
%    filename. The bitdetph is taken from the maximum value of the 3
%    matrices.
%
%    writeyuv(filename,Y,U,V,bitdepth) writes the Y, U and V components in 
%    the file filename, using the specified bitdepth.
%
%    writeyuv(filename,Y,U,V,'append') appends the Y, U and V components to
%    the file filename. The bitdepth is taken from the maximum value of the
%    3 matrices, and it does not check for frames that are already in the 
%    file.
%
%    writeyuv(filename,Y,U,V,bitdepth,'append') appends the Y, U and V 
%    components to the file filename, using the specified bitdepth.
%
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com
%    Edson Mintsu Hung
%    mintsu@gmail.com
%

%Minimum number of parameters: 2.
if (nargin <2)
    error('Not enough input parameters.')    
end

%Number of parameters: 2.
if (nargin == 2)
    write_empty_chroma = 1;
    bitdepth = 0;
    append = 0;
end

%Number of parameters: 3.
if (nargin == 3)
    if (isscalar(param3))
        write_empty_chroma = 1;
        bitdepth = param3;
        append = 0;
    else
        error('The correct usage of this function with 3 parameters is: writeyuv(filename,Y,bitdepth).')
    end
end

%Number of parameters: 4.
if (nargin == 4)
    write_empty_chroma = 0;
    U = param3;
    V = param4;
    bitdepth = 0;
    append = 0;
end

%Number of parameters: 5.
if (nargin == 5)
    write_empty_chroma = 0;
    U = param3;
    V = param4;
    if (isscalar(param5) == 1)
        bitdepth = param5;
        append = 0;
    elseif (strcmp(param5,'append') == 1)
        bitdepth = 0;
        append = 1;
    else
        error('The 5th parameter must be either the bitdepth or the keywork ''append''.')
    end
end

%Number of parameters: 6.
if (nargin == 6)
    write_empty_chroma = 0;
    U = param3;
    V = param4;
    bitdepth = param5;
    if (strcmp(param6,'append') == 1)
        append = 1;
    else
        error('Unrecognized keyword. Type help writeyuv for help.')
    end
end

%Number of parameters > 5.
if (nargin > 6)
    error('Too many input parameters')
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Checks the sizes of the Y,U,V elements.
[wy hy ny] = size(Y);

if (write_empty_chroma == 0)
    [wu hu nu] = size(U);
    [wv hv nv] = size(V);
    
    if ((ny ~= nu) || (ny ~= nv) || (nu ~= nv))
        error('The input Y, U, V matrices do not have the same number of frames.')
    end
    
    if ((hu ~= hv) || (wu ~= wv))
        error('The size of the chrominance components does not match.')
    end
    
    
    if (not(((wy == wu) && (hy == hu)) || ((wy/2 == wu) && (hy/2 == hu))) == 1)
        error('The chrominance component should be the same size, or a quarter of the size, of the luminance component')
    end
    
    nframes = ny;
    n_elements_luma = wy * hy;
    n_elements_chroma = wu * hu;    
else
    nframes = ny;
    n_elements_luma = wy * hy;
    n_elements_chroma = (wy/2) * (hy/2);    
end


%%%%%%%%%%%%%%%%%%%%%%%%%
%Changes the datatype according to the bitdepth.
if (bitdepth == 0) %If the bitdepth is 0, it will guess the bitdepth according to the data.
    max_value = max(max(max(Y)));
    
    if (write_empty_chroma == 0)
        maxU = max(max(max(U)));
        maxV = max(max(max(V)));
        
        if (max_value < maxU)
            max_value = maxU;            
        end
        if (max_value < maxV)
            max_value = maxV;
        end
    end
    
    n = ceil(log2(double(max_value)));
    
    if (n < 8)
        bitdepth = 8;
    else
        bitdepth = n;
    end
end
    
if (bitdepth < 8)
    error('The minimum bitdepth should be 8.')
elseif (bitdepth == 8)
    datatype = 'uint8';
    
    %Changes the datatype (there might be loss of data).
    Y = uint8(Y);
    if (write_empty_chroma == 0)
        U = uint8(U);
        V = uint8(V);
    else
        empty_chroma_frame = uint8(zeros(n_elements_chroma,1));
    end
    
elseif (bitdepth <= 16)
    datatype = 'uint16';
    
    %Changes the datatype (there might be loss of data).
    Y = uint16(Y);
    if (write_empty_chroma == 0)
        U = uint16(U);
        V = uint16(V);
    else
        empty_chroma_frame = uint16(zeros(n_elements_chroma,1));
    end
elseif (bitdepth <= 32)
    datatype = 'uint32';
    
    %Changes the datatype (there might be loss of data).
    Y = uint32(Y);
    if (write_empty_chroma == 0)
        U = uint32(U);
        V = uint32(V);
    else
        empty_chroma_frame = uint32(zeros(n_elements_chroma,1));
    end
else
    error('The maximum bitdepth should be 32.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Open the file.
if (append == 0)
    [fid,message] = fopen(filename,'w');
else
    [fid,message] = fopen(filename,'a');
end

%Exits the function if the file cannot be open.
if (fid == -1)
    error(message)
end
    
for (n = 1:1:nframes)
    %Writes the luma component.
    currFrameY = reshape(Y(:,:,n)',n_elements_luma,1);
    fwrite(fid,currFrameY,datatype);
    
    if (write_empty_chroma == 0)
        currFrameU = reshape(U(:,:,n)',n_elements_chroma,1);
        fwrite(fid,currFrameU,datatype);
        
        currFrameV = reshape(V(:,:,n)',n_elements_chroma,1);
        fwrite(fid,currFrameV,datatype);        
    else
        %Writes the empty chroma frame twice.
        fwrite(fid,empty_chroma_frame,datatype);
        fwrite(fid,empty_chroma_frame,datatype);        
    end    
end

fclose(fid);
