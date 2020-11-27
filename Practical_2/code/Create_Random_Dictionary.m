function D = Create_Random_Dictionary(dim , nAtoms)
% Creates a random dictionary, with normalized columns
% Inputs : 
% dim     : Signal dimension
% nAtoms  : Number of atoms

%% Init random stream;
s = RandStream.getDefaultStream;
reset(s);

%% Create a random dictionary
D = rand(dim , nAtoms);

%% Normalize columns
D = D ./ repmat(sqrt(sum(D.^2 , 1)) , dim , 1);

%% Done
return;