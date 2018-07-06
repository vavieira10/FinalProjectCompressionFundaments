function [Y,U,V] = convertBitDepth(param1,param2,param3,param4,param5)
%CONVERTBITDEPTH - Converts the bit depth of raw YUV matrices.
%    Y = convertBitDepth(Yin,bitDepthInput,bitDepthOutput) converts the
%    bitdepth of the luminance component in Yin and returns as Y.
%
%    [Y,U,V] = convertBitDepth(Yin,Uin,Vin,bitDepthInput,bitDepthOutput) 
%    converts the bitdepth of the luminance and chrominance components in 
%    Yin,Uin,Vin and returns as Y,U,V.
%
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com
%

if ((nargin == 3) && (nargout == 1))
    Yin = param1;
    convertChroma = 0;
    bitDepth_input = param2;
    bitDepth_output = param3;
elseif ((nargin == 5) && (nargout == 3))
    Yin = param1;
    Uin = param2;
    Vin = param3;
    convertChroma = 1;
    bitDepth_input = param4;
    bitDepth_output = param5;
else
    error('Not enough input/output parameters. Type help convertBitDepth for details.')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Effectively scale the matrices
scale_factor = 2^(bitDepth_output - bitDepth_input);
Y = double(Yin) * scale_factor;
if (convertChroma == 1)
    U = double(Uin) * scale_factor;
    V = double(Vin) * scale_factor;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Crop the values to the maximum value supported by the output bitdepth.
max_value_output = 2^bitDepth_output - 1;
Y(Y > max_value_output) = max_value_output;
if (convertChroma == 1)
    U(U > max_value_output) = max_value_output;
    V(V > max_value_output) = max_value_output;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rounds and converts it to the appropriate datatype.
if (bitDepth_output <= 8)    
    Y = uint8(round(Y));
    if (convertChroma == 1)
        U = uint8(round(U));
        V = uint8(round(V));
    end
elseif (bitDepth_output <= 16)
    Y = uint16(round(Y));
    if (convertChroma == 1)
        U = uint16(round(U));
        V = uint16(round(V));
    end
elseif (bitDepth_output <= 32)
    Y = uint32(round(Y));
    if (convertChroma == 1)
        U = uint32(round(U));
        V = uint32(round(V));
    end
end

