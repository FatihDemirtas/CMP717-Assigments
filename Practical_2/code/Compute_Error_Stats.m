function [resPSNR , resL2] = Compute_Error_Stats(trueIm , processedIm)
% Computes L2 error and PSNR between result image and known true image
%
% Inputs : 
% trueIm      : Original image, double, in [0 255]
% processedIm : Image to compute stats from
%
% Outputs :
% resPSNR     : PSNR result
% resL2       : L2 result

trueIm = double(trueIm); processedIm = double(processedIm);
sz = size(trueIm);
if max(trueIm(:)) < 1 , trueIm = trueIm * 255; end
if max(processedIm(:)) < 1 , processedIm = processedIm * 255; end

difIm = processedIm - trueIm;
difIm2 = difIm .^ 2;
resL2 = mean(difIm2(:));

nom = 255^2 * prod(sz);
denom = sum(difIm2(:));

resPSNR = 10 * log10(nom / denom);

return;

