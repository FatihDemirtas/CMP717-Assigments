function patches_all = generate_external_patches(folder_path, patchsize)
    disp('Generating patches');
    filelist = fullfile(folder_path, 'filelist.txt');

    fid = fopen(filelist);
    if fid == -1
        error('File not found');
    end

    fprintf('Reading file list from "%s"\n', filelist);
    filelist = cell(1,100);
    i = 0;

    tline = fgetl(fid);
    while ischar(tline)
        i = i + 1;
        im_path = fullfile(folder_path, tline);
        filelist(i) = {im_path};
        tline = fgetl(fid);
    end
    fclose(fid);

    filelist = filelist(1:i);
    listsize = i;

    % images are 512x512
    imsize = [512 512];


    patches_size = (imsize(1) - patchsize(1) + 1)^2;
    patches_all = zeros(patchsize(1)^2, patches_size);

    for i=1:listsize
        cur_im = imread(filelist{i});
        cur_patches = im2col(cur_im, patchsize, 'sliding');
        index_start = (i - 1) * patches_size + 1;
        index_stop = i * patches_size;
        patches_all(:, index_start:index_stop) = cur_patches;
    end

    save(fullfile(folder_path, 'patches.mat'), 'patches_all');
end