function [results_PSNR, results_img] = gather_results( folder_path, have_images)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    have_images = 0;
end

path_psnr = fullfile(folder_path, 'PSNR.mat');
load(path_psnr);

if have_images > 0
    path_img = fullfile(folder_path, 'img.mat');
    load(path_img);
else
    results_img = {0};
end

end

