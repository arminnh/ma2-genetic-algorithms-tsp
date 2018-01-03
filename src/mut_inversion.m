% low level function for TSP mutation
% reciprocal exchange : two random cities in a tour are swapped
% Representation is an integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation
%

function NewChrom = mut_inversion(OldChrom)

NewChrom = adj2path(OldChrom);

% select two positions in the tour
rndi = zeros(1,2);
while rndi(1) == rndi(2)
	rndi = randi(size(NewChrom, 2), [1, 2]);
end
rndi = sort(rndi);

% reverse a subpath in the chrom
NewChrom(rndi(1) : rndi(2)) = NewChrom(rndi(2) : -1 : rndi(1));

NewChrom = path2adj(NewChrom);

end