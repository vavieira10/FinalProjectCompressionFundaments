function computeRD(encoded_file, dec_file, original_yuv, width, height,nframes, fps)


bitdepth_original = 8;
bitdepth_dec_file = 8;
target_bitdepth   = 8;
bitdepth = [bitdepth_dec_file bitdepth_original target_bitdepth];

%Gets the Rate and PSNR for this coded sequence.
temp_a  = dir(encoded_file);
bits = temp_a.bytes * 8;
rate_encoded = ((bits)*fps)/(1000 * nframes);

[psnr_encoded,average_psnr_encoded] = computePSNR(dec_file,original_yuv,width, height, nframes, 1, bitdepth);

disp(['Rate encoded: ' num2str(rate_encoded) ' kbps.'])
disp(['PSNR encoded: ' num2str(psnr_encoded) ' dB.'])