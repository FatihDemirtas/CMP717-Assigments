function [AllMats , rng] = Show_Dictionary(inD , nImages , oneColumn)
% Displays a dictionary
% Inputs:
% * inD : input dictionary
% * nImages : the number of images represented in each atom (i.e. is the atom is 128 long, and nImages == 2, than ir means there are two 8X8 atoms).
% * oneColumn - wether to display as a matrix or all atoms in one column

if nargin < 2, nImages = 1; end
if nargin < 3, oneColumn = 0 ;end

inD_size = size(inD , 1);
eachD_size = inD_size / nImages;
AllMats = [];

for c1 = 1 : nImages
	D = inD((c1 - 1) * eachD_size + [1 : eachD_size] , :);
	
	nAtoms = size(D , 2);

	% Adding borders between the atoms
	atomSize = size(D,1); blockSz = atomSize .^ 0.5;
	inInds = [1 : atomSize];
	outInds = repmat([0 : blockSz - 1] * (blockSz + 1) , blockSz , 1) + repmat([1 : blockSz]' , 1 , blockSz); outInds = outInds(:);
	D2= zeros((blockSz + 1) .^ 2 , nAtoms);
	
	D2(outInds , :) = D(inInds , :);
	remInds = setdiff([1 : size(D2 , 1)] , outInds);
	D2(remInds , :) = -1;
	if oneColumn, D2(remInds , :) = 1; end
	blockSz = blockSz + 1;

	Dict = D2;

	% switch nAtoms
	% 	case 64
	% 		r = 8; c = 8;
	% 	case 128
	% 		r = 8; c = 16;
	% 	case 256
	% 		r = 16; c = 16;
	% 	case 512
	% 		r = 16; c = 32;
	% 	otherwise
	% 		error('Problem with dictionary size');
	% end
	if oneColumn
		% 		r = nAtoms; c = 1;
		r = 1 ; c = nAtoms;
	else
		r = nAtoms .^ 0.5; c = r;
	end
	% 	powerOfTwo = log(nAtoms) / log(2);
	% 	r = 2 ^ (ceil(powerOfTwo / 2)); c = nAtoms / r;


	finalMat = zeros([r c] * blockSz);
	
	t1 = reshape(Dict(:) , blockSz , []); % In this matrix, every blocksz adjacent rows (no overlaps) are one block

	inds = [1 : c * blockSz];
	for t = 1 : r
		finalMat((t - 1)  * blockSz + 1 : t * blockSz , :) = t1(: , inds + (t-1) * length(inds));
	end

	s = size(AllMats , 2);
	if oneColumn
		barrier = [ones([s 1])]';
	else
		barrier = [-ones([s 1]) ones([s 1]) -ones([s 2])]';
	end
	if c1 == 1, vbarrier = []; end
	if isempty(AllMats)
		if ~isempty(barrier)
			AllMats = [barrier ; finalMat];
		else
			AllMats = finalMat;
		end
	else
		AllMats = [AllMats ; barrier ; finalMat];
	end
	
end

if oneColumn
	% 	AllMats(: , end) = [];
	% 	AllMats(: , blockSz + 1) = [];
	% 	AllMats(end , :) = [];
	AllMats(end , :) = [];
% 	AllMats(blockSz + 1 , :) = [];
	AllMats(: , end) = [];
end


firstY = ceil(blockSz / 2);
nBlocks = c;
yTicks = []; 
for c1 = 1 : nImages,
	tYticks = (firstY + blockSz * [0 : nBlocks - 1] + (c1 - 1) * (size(barrier , 1) + (nBlocks * blockSz)));
	yTicks = [yTicks tYticks(1:2:end)];
end
tYlabels = [1 : nBlocks];
yLabels = repmat(tYlabels(1:2:end) , 1 , nImages);
xTicks = (firstY + blockSz * [0 : nBlocks - 1]);
xLabels = [1 : nBlocks];
xTicks = xTicks(1:2:end); xLabels = xLabels(1:2:end); 

rng = max(abs(inD(:))); rng = min(rng * 1.1 , 1);
% figure; 
multSize = floor(600 / size(AllMats , 1));
AllMats = imresize(AllMats , multSize , 'nearest');

imshow(AllMats , [-rng rng]);

if nImages > 1 & (~oneColumn)
	axis on;
	set(gca , 'XTick' , xTicks);
	set(gca , 'XTickLabel' , xLabels);
	set(gca , 'YTick' , yTicks);
	set(gca , 'YTickLabel' , yLabels);
	set(gca , 'FontSize' , 7);
	% 	set(gca , 'FontName' , 'WindowsLatin1Encoding');
end


