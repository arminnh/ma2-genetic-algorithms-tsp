% order crossover for TSP in path representation
% as described in ...
%
% Input parameters:
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual
%                (in any form, not necessarily real values).
%    PR_CROSS  - Probability of recombination occurring between pairs
%                of individuals.
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.

function NewChrom = cross_order(OldChrom, PR_CROSS)

if nargin < 2, PR_CROSS = NaN; end

[rows, cols] = size(OldChrom);
NewChrom = zeros(rows, cols);

maxrows = rows;
if rem(rows, 2) ~= 0
   maxrows = maxrows-1;
end

for row = 1:2:maxrows
    if rand < PR_CROSS
        rnd = sort(randi(cols, [1, 2]));
        a = rnd(1);
        b = rnd(2);
        
        NewChrom(row, a:b) = OldChrom(row, a:b);
        NewChrom(row+1, a:b) = OldChrom(row+1, a:b);
        
        childOneIdx = rem(b, cols) + 1;
        childTwoIdx = rem(b, cols) + 1;
        for i = 1:cols
            current = rem(b + i-1, cols) + 1;
            
            parentOneValue = OldChrom(row, current);
            if (all(NewChrom(row+1, :) ~= parentOneValue))
                NewChrom(row+1, childTwoIdx) = parentOneValue;
                childTwoIdx = rem(childTwoIdx, cols) + 1;
            end
            
            parentTwoValue = OldChrom(row+1, current);
            if (all(NewChrom(row, :) ~= parentTwoValue))
                NewChrom(row, childOneIdx) = parentTwoValue;
                childOneIdx = rem(childOneIdx, cols) + 1;
            end
        end
    else
		NewChrom(row,:)=OldChrom(row,:);
		NewChrom(row+1,:)=OldChrom(row+1,:);
    end
end
end

