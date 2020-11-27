function [results_PSNR, results_img] = Image_Denoising_Test_Custom(Im, params, debug_mode)
% -------------------------------------------------------------------------
%
% This function is edited by Fatih Demirtas due to lack of ease of usage.
%
% Added features:
%           * params       : includes all parameters of algorithm.
%           * results_PSNR : PSNR result is returned.
%           * results_img  : Resulted Images are returned.
% -------------------------------------------------------------------------

% Run synthetic denoising tests using neveral methods.
% noiseSig is the standard deviation of the noise

% [noisy_image_PSNR, DCT_wo_PSNR, DCT_w_PSNR, trained_PSNR]
results_PSNR = zeros(1, 4);
size_of_image = size(Im);
results_img = zeros(size_of_image(1), size_of_image(2), 4);

% Convert uint8 to double
trueIm = double(Im);

params.groundTruthData.groundTruthIm = trueIm;

noiseSig = params.noiseSig;

% Add noise
noisyIm = Add_Noise_To_Image(trueIm , noiseSig, 1);
noisyPSNR = Compute_Error_Stats(trueIm , noisyIm);
results_img(:, :, 1) = noisyIm;
results_PSNR(1) = noisyPSNR;

if(debug_mode == true)
    figure; 
    imshow(noisyIm , []); 
    title(sprintf('noisy image  : %02.2f dB' ,noisyPSNR) );
end

%======================================================

% Run denoising with a fixed dictionary without overlaps
disp('Applying the local patch-based image denoising algorithm with DCT  and no overlaps');
DCTdict = Build_DCT_Overcomplete_Dictionary(params.nAtoms , params.patchSize);
ResIm_NoOverlap = Image_Denoising_Patches(noisyIm , DCTdict , params);
resDCTPSNR = Compute_Error_Stats(trueIm , ResIm_NoOverlap);
results_img(:, :, 2) = ResIm_NoOverlap;
results_PSNR(2) = resDCTPSNR;

if(debug_mode == true)
    figure; imshow(ResIm_NoOverlap , []);   title(sprintf('DCT, no overlap : %02.2f dB' ,resDCTPSNR) );
    disp(['     PSNR = ',num2str(resDCTPSNR)]);
    disp('   ');
end

% Run denoising with a fixed dictionary with overlaps
disp('Applying the local patch-based image denoising algorithm with DCT  with overlaps');
DCTdict = Build_DCT_Overcomplete_Dictionary(params.nAtoms , params.patchSize);
ResIm_WithOverlap = Image_Denoising_Patches_Overlap(noisyIm , DCTdict , params);
resDCToverlapPSNR = Compute_Error_Stats(trueIm , ResIm_WithOverlap);
results_img(:, :, 3) = ResIm_WithOverlap;
results_PSNR(3) = resDCToverlapPSNR;

if(debug_mode == true)
    figure; imshow(ResIm_WithOverlap , []);   title(sprintf('DCT, with overlap : %02.2f dB' ,resDCToverlapPSNR) );
    disp(['     PSNR = ',num2str(resDCToverlapPSNR)]);
    disp('   ');
end

% Run denoising with K-SVD learning and overlaps
disp('Applying the local patch-based image denoising algorithm with K-SVD and overlaps');
ResIm_Trained = Image_Denoising_Trained_Dictionary(noisyIm , params);
resTrainedPSNR = Compute_Error_Stats(trueIm , ResIm_Trained);
results_img(:, :, 4) = ResIm_Trained;
results_PSNR(4) = resTrainedPSNR;

if(debug_mode == true)
    figure; imshow(ResIm_Trained , []);   title(sprintf('With trained dictionary : %02.2f dB' ,resTrainedPSNR) );
    disp(['     PSNR = ',num2str(resTrainedPSNR)]);
    disp('   ');
end

return;
