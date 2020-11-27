function ResIm = Image_Denoising_Patches_Overlap(Im , D , param)
% Denoise image by denoising its patches, using a pre-determined dictionary.
% Patches are denoised WITH overlap.
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

% Divide the image to blocks
imPatches = im2col(Im , patchSize , 'sliding');

% Denoise each patch using OMP
resPatches = Batch_OMP(D , imPatches , param);

% Reconstruct the image by averaging the patches in the overlap area
ResIm = Average_Overlapping_Patches(resPatches, size(Im) , patchSize);

% Finished
return;
	

