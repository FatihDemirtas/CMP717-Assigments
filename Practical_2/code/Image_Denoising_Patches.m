function ResIm = Image_Denoising_Patches(Im , D , param)
% Denoise image by denoising its patches, using a pre-determined dictionary.
% Patches are denoised WITHOUT overlap.
%
% Inputs : 
% Im      : image to denoise, double, [0 255]
% D       : dictionary (normalized columns)
% param   : stopping condition, containing at least one field of
%         'patchSize' (must fit the dictionary)
%         'errorGoal' for OMP
%
% Outputs :
% ResIm   : Result Image

% Rename parameters
patchSize = param.patchSize;

% Add borders to the image, if size is not multiple of patch size
brdrIm = Im;

extraRows = mod(size(Im,1) , patchSize(1));
nAddRows = mod(patchSize(1) - extraRows , patchSize(1));
if (extraRows ~= 0) 
	brdrIm = [brdrIm ; brdrIm(end : -1 : (end-nAddRows+1) , :)];
end

extraCols = mod(size(Im,2) , patchSize(2));
nAddCols = mod(patchSize(2) - extraCols , patchSize(2));
if (extraCols ~= 0) 
	brdrIm = [brdrIm brdrIm(: , end : -1 : (end-nAddCols+1))];
end

% Divide the image to blocks
brdrImPatches = im2col(brdrIm , patchSize , 'distinct');

% Denoise each patch using OMP
resPatches = Batch_OMP(D , brdrImPatches , param);

% Reconstruct the image
resBrdrIm = col2im(resPatches , patchSize , size(brdrIm) , 'distinct');

% Remove the border
ResIm = resBrdrIm(1 : end - nAddRows , 1 : end - nAddCols);

