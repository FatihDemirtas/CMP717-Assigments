function ResIm = Image_Denoising_Trained_Dictionary_Custom(Im , param)
% Denoise image by denoising its patches, using a pre-determined dictionary.
% Patches are denoised WITH overlap.
%
% Inputs : 
% Im      : image to denoise, double, [0 255]
% param   : stopping condition, containing at least one field of
%         'patchSize' (must fit the dictionary)
%         'errorGoal' for OMP
%
% Outputs :
% ResIm   : Result Image

% Rename parameters
patchSize = param.patchSize;

im1 = double(imread('../peppers256.png'));
im2 = double(imread('../foreman.tif'));

size_orig = size(param.groundTruthData.groundTruthIm);

total_size = size(im1) + size(im2) + size_orig;

imPatches_all = zeros(total_size);

imPatch1 = im2col(im1, patchSize, 'sliding');
imPatch2 = im2col(im1, patchSize, 'sliding');
% Divide the image to blocks
imPatch3 = im2col(Im , patchSize , 'sliding');

size_imp1 = size(imPatch1);
size_imp2 = size(imPatch2);
size_imp3 = size(imPatch3);
start1 = 1;
start2 = 1;
stop1 = size_imp1(1);
stop2 = size_imp1(2);

imPatches_all(start1:stop1, start2:stop2) = imPatch1(:, :);

start1 = stop1 + 1;
start2 = stop2 + 1;
stop1 = stop1 + size_imp2(1);
stop2 = stop2 + size_imp2(2);

imPatches_all(start1:stop1, start2:stop2) = imPatch2(:, :);

start1 = stop1 + 1;
start2 = stop2 + 1;
stop1 = stop1 + size_imp3(1);
stop2 = stop2 + size_imp3(2);

stop1 - start1
stop2 - start2

size_imp3

imPatches_all(start1:stop1, start2:stop2) = imPatch3(:, :);

% indexes = randperm(size(imPatches_all,2), size_imp3(2));
% 
% imPatches = imPatches_all(:, indexes);

% Train a dictionary
D = Train_Dictionary(imPatches_all, param);

% Denoise each patch using OMP
resPatches = Batch_OMP(D , imPatches , param);

% Reconstruct the image by averaging the patches in the overlap area
ResIm = Average_Overlapping_Patches(resPatches, size(Im) , patchSize);

% Finished
return;