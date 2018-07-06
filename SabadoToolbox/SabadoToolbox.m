function SabadoToolbox
%SABADOTOOLBOX A toolbox to work with YUV (RAW) Video files.
%    This toolbox main functions are:
%    FILE IO:
%    READYUV - Reads YUV files and returns the sequence as matlab
%              variables.
%    WRITEYUV - Writes matlab YUV variables as YUV files.
%    CROPSEQUENCE - Crops the resolution of a YUV file.
% 
%    QUALITY and PRECISION:
%    PSNR - computes the PSNR between matlab YUV variables
%    COMPUTEPSNR - computes the PSNR between YUV files.
%    CONVERTBITDEPTH - converts the bitdepth precision of matlab YUV
%                      variables.
%
%    DEPRECATED FUNCTIONS:
%    PSNRFRAMES - Computes and displays the PSNR of each frame between two
%                 YUV files.
%    YUV2RGB - Converts YUV matlab variables to the RGB colourspace.
%    RGB2YUV - Converts RGB matlab variables to the YUV colourspace.
%
%    TODO (for later versions)
%    Change the image dimension convention from using two variables (w,h)
%    to use only one that can be used either as numerical ([w h]) or as 
%    string ('qcif').
%
%    Version: 3.0
%    Date:    15/07/2011
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com
%    Edson Mintsu Hung
%    mintsu@gmail.com
%

%Adds this folder to the MATLAB path.
src = pwd;
addpath(src);