function [Y,U,V] = readyuv(filename_in, w, h, param4, param5,param6)
%READYUV - Reads video files in YUV format (raw).
%   function [Y,U,V] = readyuv(filename_in, w, h, nframes, bitdepth, 
%                              isYUV444)
%
%   Y = readyuv(filename_in,w,h,nframes) reads nframes frames from file 
%       filename_in, of size w x h, and returns just the luminance 
%       component in Y.
%
%   Y = readyuv(filename_in,w,h,[frame_start frame_end]) reads the frames 
%       in the range [frame_start frame_end] frames from file filename_in, 
%       of size (w x h), and returns just the luminance component in Y. 
%       Note that the number of frames read in this case is 
%       (frame_end - frame_start + 1), and that the first frame is 
%       considered to be frame 0. Thus, these forms:
%         - readyuv(filename_in,w,h,5) 
%         - readyuv(filename_in,w,h,[0 4])
%         are equivalent, and both will read the first 5 frames.
%
%   Y = readyuv(filename_in,w,h) reads all frames from file filename_in, of
%       size (w x h), and returns just the luminance component in Y. (if 
%       the number of frames is known beforehand, it is advised to use it, 
%       as this might be considerably slower).
%
%   [Y,U,V] = readyuv(filename_in,w,h,nframes) reads nframes frames from 
%       file filename_in, of size (w x h), and returns the luminance and 
%       chrominance components in Y, U and V. If (nframes = 0), then all 
%       frames in the file will be read.       
%
%   Y = readyuv(filename_in,w,h,nframes,bitdepth) reads nframes frames from
%       file filename_in, of size (w x h), and returns just the luminance 
%       component in Y. The reading is done in the correct bitdepth 
%       (default = 8). The chroma components are skipped.
%
%   [Y,U,V] = readyuv(filename_in,w,h,nframes,bitdepth,isYUV444) reads 
%       nframes frames from file filename_in, of size w x h, and returns 
%       the luminance and chrominance components in Y, U and V. The reading
%       is done in the correct bitdepth (default = 8), and the size of the 
%       chroma components depends on isYUV444:
%        0 - number_of_elements_chroma = (1/4) * number_of_elements_luma
%        1 - number_of_elements_chroma = number_of_elements_luma
%        default = 0.
%
%   Y = readyuv(filename_in,w,h,nframes,bitdepth,isYUV444) reads nframes 
%       frames from file filename_in, of size (w x h), and returns just the
%       luminance component in Y. The reading is done in the correct 
%       bitdepth (default = 8). The number of chroma components are skipped
%       according to the parameter isYUV444.
%
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com
%    Edson Mintsu Hung
%    mintsu@gmail.com
%


%%Colocar comando [Y,U,V] = readyuv(filename_in,176,144,300) e mudar
%%filename_in
%Minimum number of parameters: 3.
if (nargin <3)
    error('Not enough input parameters.')    
end

%Number of parameters: 3.
if (nargin == 3)
    nframes_skip = 0;
    nframes = 0;
    bitdepth = 8;
    isYUV444 = 0;
end

%Number of parameters: 4.
if (nargin == 4)
    switch(numel(param4))
        case 1
            nframes_skip = 0;
            nframes = param4;
        case 2
            nframes_skip = param4(1);
            nframes = param4(2) - nframes_skip + 1;
        otherwise
    end
    bitdepth = 8;
    isYUV444 = 0;
end

%Number of parameters: 5.
if (nargin == 5)
    switch(numel(param4))
        case 1
            nframes_skip = 0;
            nframes = param4;
        case 2
            nframes_skip = param4(1);
            nframes = param4(2) - nframes_skip + 1;
        otherwise
    end
    bitdepth = param5;
    isYUV444 = 0;
end

%Number of parameters: 6.
if (nargin == 6)
    switch(numel(param4))
        case 1
            nframes_skip = 0;
            nframes = param4;
        case 2
            nframes_skip = param4(1);
            nframes = param4(2) - nframes_skip + 1;
        otherwise
    end
    bitdepth = param5;
    isYUV444 = param6;
end

%Number of parameters > 6.
if (nargin > 6)
    error('Too many input parameters')
end

%Indicates what will be read:
read_chroma = 0;
switch (nargout)
    case 0
        error('Not enough output parameters.')
    case 1
        read_chroma = 0;        
    case 2
        error('It should either read only the Y component or Y, U and V')
    case 3
        read_chroma = 1;
    otherwise
        error('Too many output parameters.')
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%
%Changes the datatype according to the bitdepth.
if (bitdepth < 8)
    error('The minimum bitdepth should be 8.')
elseif (bitdepth == 8)
    datatype = 'uint8=>uint8';
    nBytes = 1;
elseif (bitdepth <= 16)
    datatype = 'uint16=>uint16';
    nBytes = 2;
elseif (bitdepth <= 32)
    datatype = 'uint32=>uint32';
    nBytes = 4;
else
    error('The maximum bitdepth should be 32.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Checks the number of frames that will be read.
if (nframes_skip < 0)
    error('The starting frame should be a positive value.')
end
if (nframes <= 0)
    error('The size of the interval should be a positive value.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Gets the number of elements in a luma or chroma frame.
n_elements_luma = (w*h);
if (isYUV444 == 0)
    n_elements_chroma = (w*h)/4;
else
    n_elements_chroma = (w*h);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Open the file.
[fid,message] = fopen(filename_in,'r');

%Exits the function if the file cannot be open.
if (fid == -1)
    error(message)
end

%%%%%%%%%%%%%%%%%%%%%%%%
%Create the output variables
if (nframes ~= 0)
    Y = zeros(h,w,nframes);
else
    Y = []; %In this case, I cannot help but make the variable grow inside the loop.
end

if (read_chroma == 1)
    if (nframes ~= 0)
        U = zeros(h/2,w/2,nframes);
        V = zeros(h/2,w/2,nframes);
    else
        U = [];
        V = [];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%
nFrames_read = 0;
stop_loop = 0;
currFrameY = [];
currFrameU = [];
currFrameV = [];

%%%%%%%%%%%%%%%%%%%%%%%%
%Skips some frames.
if (nframes_skip > 0)
    for (k = 1:1:nframes_skip)
        st = fseek(fid,(n_elements_luma + 2 * n_elements_chroma) * nBytes,'cof');
        if (st == -1)
            disp('Unable to read frames - reached the end of the file.');
            stop_loop = 1;            
        end
    end
end

while (stop_loop == 0)
    %Reads n_elements_luma in the file.
    [img,count] = fread(fid,n_elements_luma,datatype);
    
    %Checks if the required number of elements was read.
    if (count == n_elements_luma)
        currFrameY = reshape(img,w,h)';
    else
        stop_loop = 1;
    end
    
    if (read_chroma == 1)
        %Reads n_elements_chroma in the file.
        [img,count] = fread(fid,n_elements_chroma,datatype);
        
        %Checks if the required number of elements was read.
        if (count == n_elements_chroma)
            currFrameU = reshape(img,w/2,h/2)';
        else
            stop_loop = 1;
        end
        
        %Reads n_elements_chroma in the file.
        [img,count] = fread(fid,n_elements_chroma,datatype);
        
        %Checks if the required number of elements was read.
        if (count == n_elements_chroma)
            currFrameV = reshape(img,w/2,h/2)';
        else
            stop_loop = 1;
        end      
    else
        %Jumps the chroma components.
        st = fseek(fid,2 * n_elements_chroma * nBytes,'cof');
        if (st == -1)
            stop_loop = 1;            
        end
    end
    
    %If it could successfully read this frame.
    if (stop_loop == 0)
        nFrames_read = nFrames_read + 1;
        Y(:,:,nFrames_read) = currFrameY;
        if (read_chroma == 1)
            U(:,:,nFrames_read) = currFrameU;
            V(:,:,nFrames_read) = currFrameV;            
        end
        
        if ((nframes ~= 0) && (nFrames_read == nframes))
            stop_loop = 1;
        end
    end
    
end
    
%Close the file
fclose(fid);    

%Convert to the correct the datatype.
if (nBytes == 1)
    Y = uint8(Y);
    if (read_chroma == 1)
        U = uint8(U);
        V = uint8(V);
    end
elseif (nBytes == 2)
    Y = uint16(Y);
    if (read_chroma == 1)
        U = uint16(U);
        V = uint16(V);
    end
elseif (nBytes == 4)
    Y = uint32(Y);
    if (read_chroma == 1)
        U = uint32(U);
        V = uint32(V);
    end
end
