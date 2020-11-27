function noisyIm = Add_Noise_To_Image(trueIm , noiseSig, initRandom)
% Adds synthetic, additive white Gaussian noise to an image. Values are clipped to [0 , 255]
%
% Inputs : 
% trueIm     : Original image, double, in [0 255]
% noiseSig   : STD of the noise
% initRandom : (optional) 1 to init the random number generator (default), 0 to not init
%
% Outputs :
% noisyIm    : Image with noise added to it


% Initialize random number generator
if nargin < 3, initRandom = 1; end; % Default : initialize the number generator
if initRandom
    randn('state',0)    
    % s = RandStream.getDefaultStream;
	% reset(s);
end

% Add noise
noisyIm = trueIm + randn(size(trueIm)) * noiseSig;

% Clip out of bounds values
noisyIm(noisyIm < 0) = 0;
noisyIm(noisyIm > 255) = 255;

%% finished
return;
