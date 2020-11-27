close all
clear all
clc

cd('.');

mkdir('output_plots');

results_PSNR = zeros(12, 3, 4);
results_img = cell(12, 3);

arr = 5:5:60;

pattern = 'sigma%datoms144size4';
pattern_replaced = strrep(pattern, '%d', 'X');

for sigma=arr
    folder_path = sprintf(pattern, sigma);
    fprintf('Reading folder %s\n', folder_path);
    [results_PSNR(sigma/5, :, :), results_img(sigma/5, :)] = ...
        gather_results(folder_path);
end


data_count = size(results_PSNR, 1);
image_count = size(results_PSNR, 2);

noisy_psnr = zeros(image_count, data_count);
dct_wo_ovr_psnr = zeros(image_count, data_count);
dct_w_ovr_psnr = zeros(image_count, data_count);
ksvd_psnr = zeros(image_count, data_count);

noisy_psnr(1:3, :) = results_PSNR(:, 1:3, 1)';
dct_wo_ovr_psnr(1:3, :) = results_PSNR(:, 1:3, 2)';
dct_w_ovr_psnr(1:3, :) = results_PSNR(:, 1:3, 3)';
ksvd_psnr(1:3, :) = results_PSNR(:, 1:3, 4)';

xscale = 5:5:60;

plot(xscale, ksvd_psnr' - dct_w_ovr_psnr');
legend('barbara.png','foreman.tif', 'peppers256.png');
ylabel('K-SVD Gain over DCT with Overlap Method');
xlabel('Sigma Values');
grid on
print('-dpng', fullfile('output_plots', [pattern_replaced '.png']));

% for i=1:data_count
%     for j=1:image_count
%         imageset = uint8(results_img{i, j});
%         figure
%         for k=1:4
%             subplot(2, 2, k)
%             imshow(imageset(:, :, k))
%             title(sprintf('PSNR %f', results_PSNR(i, j, k)));
%         end
%     end
% end
