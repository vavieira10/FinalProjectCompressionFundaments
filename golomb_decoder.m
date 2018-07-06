function [motionVectors] = golomb_decoder(bitstream)
lengthq = 0;
simbolo = [];
counter = 1;
i = 1;
while(i<length(bitstream))
switch bitstream(i)
    case '1'
        if lengthq == 0
            simbolo(counter) = 0;
            i = i + 1;
            counter = counter + 1;
        else
            x = bin2dec(bitstream(i+1 : i+lengthq));
            simbolo(counter) = 2^lengthq + x -1;
            i = i + lengthq + 1;
            lengthq = 0;
            counter = counter + 1;
        end
    case '0'
         lengthq = lengthq + 1;
         i = i+1;
end


end
[~,N]=size(simbolo);
for j=1:N
simbolo(j) = (-1)^(simbolo(j)+1)*ceil(simbolo(j)/2);
motionVectors = simbolo;
end
end