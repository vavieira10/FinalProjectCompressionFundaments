function cropSequence(filenameIn,filenameOut,h_in,w_in,h_out,w_out,nframes,param8,param9)
%CROPSEQUENCE - Crop video sequences in YUV format (raw).
%   function cropSequence(filenameIn,filenameOut,h_in,w_in,h_out,w_out,
%                         nframes, bitdepth, isYUV444)
%
%   cropSequence(filenameIn,filenameOut,h_in,w_in,h_out,w_out,nframes)
%   crops the sequence in filenameIn and saves it in a file named
%   filenameOut. The dimension of the input sequence is (w_in x h_in), and 
%   the dimensions of the output sequence is (w_out x h_out). 
%
%   cropSequence(filenameIn,filenameOut,h_in,w_in,h_out,w_out,nframes,
%                bitdepth) crops the sequence in filenameIn and saves it in
%   a file named filenameOut. The image is read and saved with the 
%   corresponding bitdepth (default = 8).
%
%   cropSequence(filenameIn,filenameOut,h_in,w_in,h_out,w_out,nframes,
%                bitdepth,isYUV444)
%   crops the sequence in filenameIn and saves it in a file named
%   filenameOut. If (isYUV444 = 1), the size of the chroma component is 
%   considered the same as the luma component (default = 0).
%
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com
%


%Minimum number of parameters: 7.
if (nargin <7)
    error('Not enough input parameters.')    
end

%Number of parameters: 7.
if (nargin == 7)
    bitdepth = 8;
    isYUV444 = 0;
end

%Number of parameters: 8.
if (nargin == 8)
    bitdepth = param8;
    isYUV444 = 0;
end

%Number of parameters: 9.
if (nargin == 8)
    bitdepth = param8;
    isYUV444 = param9;
end

%Number of parameters > 9.
if (nargin > 9)
    error('Too many input parameters')
end

%Checks if the output size is smaller than the input size
if ((h_out > h_in) || (w_out > w_in))
    error('The output size is bigger than the input size.');
end

if ((rem(h_out,2) ~= 0) || (rem(w_out,2) ~= 0))
    error('The output dimensions are not divisible by two.');
end

%Loop through the frames
for (n = 0:1:(nframes-1))
    %disp(['Processing frame ' num2str(n) ' out of ' num2str(nframes) ' .']);
    
    [Y,U,V] = readyuv16(filenameIn,h_in,w_in,[n n],bitdepth,isYUV444);
    
    %Crops the frame
    Yo = Y(1:w_out,1:h_out);
    Uo = U(1:(w_out/2),1:(h_out/2));
    Vo = V(1:(w_out/2),1:(h_out/2));
    
    writeyuv16(filenameOut,Yo,Uo,Vo,bitdepth,'append');
end
