function [trueA , trueX , noisyX] = Create_Random_Singals(D , nSignals , avgCard, fixedCard, sigA, sigN)

%% Init random stream;
s = RandStream.getDefaultStream;
reset(s);

%% Get parameters
dim = size(D,1);
nAtoms = size(D,2);

%% Randomize coefficients for all
trueA = randn(nAtoms , nSignals) * sigA;

%% Select coefficients to remove
if fixedCard
	
	%% Generate signals with constant, known cardinality
	randNumber = rand(nAtoms , nSignals);
	[~,t] = sort(randNumber , 1); 
	trueA(t>avgCard) = 0; 

else
	
	%% Generate signals with known average cardinality
	coeffCoinToss = rand(nAtoms , nSignals);
	
	% The probability of a single coefficient to stay is (avgCard / dim)
	% So we randomize a number for each, all below this value stay,
	% all above this number are zeroed.
	trueA(coeffCoinToss > (avgCard / nAtoms)) = 0;
end

%% Compute the true signals themselves
trueX = D * trueA;

%% Compute the noisy signals
noisyX = trueX + randn(size(trueX)) * sigN;

%% finished
return;