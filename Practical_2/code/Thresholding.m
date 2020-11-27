function [resX , resA] = Thresholding(D , X , param)
% Run Thresholding algorithm for finding a sparse approximation for a set of signals
%
% Inputs : 
% D     : dictionary (normalized columns)
% X     : set of vectors to run on (each column is one signal)
% param : stopping condition, with the fields 'errorGoal' and 'noiseSig' 
%
% Outputs :
% resX  : The result vectors
% resA  : Sparse coefficient matrix

%% Get parameters and allocate result
dim = size(D , 1);
nAtoms = size(D , 2);
nSignals = size(X , 2);

% Compute the actual error goal, and account for noise and signal length
errorGoal = param.errorGoal * dim * (param.noiseSig.^2); 

%% Allocate results
resA = zeros(nAtoms , nSignals);
resX = zeros(dim , nSignals);

%% Compute DtD and DtX
DtX = D' * X; % This might not work for a large number of signals. 
              % It is usedful to break X into groups of signals in that case
			  % Alternatively, this can be computed for each signal, however, this is slower

%% Run on each signal
for cSig = 1 : nSignals
	
	%% Process one signal
	% get the signal
	x = X(: , cSig);
	
	% order the inner products in decreasing magnitude
	[~, srtTrns] = sort(abs(DtX(: , cSig)) , 'descend');
	
	% initialize the residual
	resid = x;
	currA_S = [];
	currInds = [];
	xcurr = zeros(dim , 1);
	
	% run until convergence
	currCard = 0;
	while (sum(resid.^2) > errorGoal)
		
		% update cardinality
		currCard = currCard + 1;
		
		% current indices - the atoms with the largest currCard coefficients
		currInds = srtTrns(1 : currCard);
		
		% Compute LS
		currA_S = D(: , currInds) \ x;
		
		% Compute current estimate and residual 
		xcurr = D(: , currInds) * currA_S;
		resid = x - xcurr;
	end
	
	% store results
	resA(currInds , cSig) = currA_S;
	resX(: , cSig) = xcurr;
	
end

%% finished
return;