%% Main Script of Problem 1.1
close all;
clear
clc
%% Images

filenames = {'../barbara.png' '../foreman.tif' '../peppers256.png'};
numberOfImages = size(filenames, 2);

%% Initialize Parameters
% various parameters
% OMP param
param.errorGoal = 1.15;

% Dictionary training param
param.method = 'KSVD';
% param.method = 'MOD';

% Number of Iteration
param.nIterations = 15;
param.useLessAtoms = [0.1 0.1 0.2 0.2 0.4 0.4 0.7 0.7 1 1 1 1 1 1 1];

% param.initType = 'RandomPatches';
param.initType = 'DCT';
param.externalTrain = 0;

%% Test is run here
results_PSNR = zeros(numberOfImages, 4);
size(results_PSNR)
results_img = cell(1, numberOfImages);

for patch_size = 8
    param.patchSize = [patch_size patch_size];
    param.groundTruthData.patchSize = param.patchSize;
    for sigma = linspace(5,60,12)
        param.noiseSig = sigma;
        for n_atoms = [64] % 81 100 121 144]
            param.nAtoms = n_atoms;
            for i=1:numberOfImages
                img = imread(filenames{i});
                [local_PSNRs, local_imgs] = Image_Denoising_Test_Custom(img, param, true);
                results_img(i) = {local_imgs};
                results_PSNR(i, :) = local_PSNRs;
            end
            
            folder_path = sprintf('../results/sigma%datoms%dsize%d/', param.noiseSig, ...
                param.nAtoms, param.patchSize(1));
            
            mkdir(folder_path);
            
            save(strcat(folder_path, 'img.mat'), 'results_img');
            save(strcat(folder_path, 'PSNR.mat'), 'results_PSNR');
        end
    end
end
