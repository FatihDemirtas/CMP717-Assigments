function ResIm = Average_Overlapping_Patches(patches, sz , patchSize )
% Reconstruct image, by averaging overlapping patches (e.g., creates by im2col(... , 'sliding'))
%
% Inputs : 
% patches   : A set of patches, each column is one patch. 
%             Assumed to be created from im2col(..,'sliding') or processing the result of this function. 
% sz        : Size of image to reconstruct
% patchSize : Size of the patch ( [height width] )
%
% Outputs :
% ResIm   : Result Image

%% Allocate the target image
ResIm = zeros(sz);

%% Reconstruct the image, Step 1: Insert all patches
% Each row in the patches data is a "sub-image", according to the location in the patch
% It is faster to loop over the pixels in the patches, instead of over the patches
inPatchInd = 0;
for cx = 1 : patchSize(2)
	for cy = 1 : patchSize(1)
		inPatchInd = inPatchInd + 1;
		
		ResIm((0 : (sz(1) - patchSize(1))) + cy , (0 : (sz(2) - patchSize(2))) + cx) = ...
			ResIm((0 : (sz(1) - patchSize(1))) + cy , (0 : (sz(2) - patchSize(2))) + cx) + ...
			reshape(patches(inPatchInd , :) , sz - patchSize + 1);
	end
end

%% Reconstruct the image, Step 2: Normalize each pixel by number of patches it is in
normX = min(min((1 : sz(2)) , (sz(2):-1:1)) , patchSize(2));
normY = min(min((1 : sz(1)) , (sz(1):-1:1)) , patchSize(1));
[normXm , normYm] = meshgrid(normX , normY);
normPix = normXm .* normYm;
ResIm = ResIm ./ normPix;