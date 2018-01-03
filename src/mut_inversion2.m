% low level function for TSP mutation

function NewChrom = mut_inversion2(OldChrom)

NewChrom = adj2path(OldChrom);

% select two positions in the tour
rndi = zeros(1,2);
while rndi(1) == rndi(2)
	rndi = randi(size(NewChrom, 2), [1, 2]);
end
rndi = sort(rndi);

% reverse a subpath in the chrom
reversed_subpath = NewChrom(rndi(2) : -1 : rndi(1));

tmp = [ NewChrom(1:rndi(1)-1) NewChrom(rndi(2)+1:size(NewChrom, 2)) ];
if (isempty(tmp))
    NewChrom = reversed_subpath;
else
    idx = randi(size(tmp, 2));
    NewChrom = [ tmp(1:idx) reversed_subpath tmp(idx+1:size(tmp, 2)) ];
end

NewChrom = path2adj(NewChrom);

end