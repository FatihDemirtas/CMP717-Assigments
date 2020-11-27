function DCT = Build_DCT_Overcomplete_Dictionary(nAtoms , blockSize)
% Creates an overcomplete 2D-DCT dictionary.
%
% Inputs : 
% nAtoms     : Number of atoms (actual number of atoms is the smallest number, larger than nAtoms, which is a square)
% blockSize  : Atom size, hxw (must be that h == w)
%
% Outputs :
% DCT        : Output dictionary with normalized columns

%% Make sure block is square
if (blockSize(1) ~= blockSize(2)), error('This only works for square blocks'); end;

%% Create DCT for one axis
Pn = ceil(sqrt(nAtoms));
DCT = zeros(blockSize(1) , Pn);

for k = 0 : 1 : Pn - 1
	V = cos([ 0 : 1 : blockSize(1) - 1] * k * pi / Pn);
	if (k > 0), V = V - mean(V); end;
	DCT(: , k+1) = V / norm(V);
end

%% Create the DCT for both axes
DCT = kron(DCT , DCT);

%% finished
return;
