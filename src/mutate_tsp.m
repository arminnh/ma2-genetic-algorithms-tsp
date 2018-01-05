% MUTATE_TSP.M (Mutation for TSP high-level function)
%
% This function takes a matrix OldChrom containing the 
% representation of the individuals in the current population,
% mutates the individuals and returns the resulting population.
%
% Input parameters:
%    MUT_F          - String containing the name of the mutation function
%    OldChrom       - Matrix containing the chromosomes of the old
%                     population. Each line corresponds to one individual.
%    Representation - The TSP representation the given population is in.
%    PR_MUT         - (optional) Scalar containing the probability of 
%                     mutation. If omitted, 0.05 is assumed.
%    SUBPOP         - (optional) Number of subpopulations. 
%                     if omitted or NaN, 1 subpopulation is assumed
%
% Output parameter:
%    NewChrom       - Matrix containing the chromosomes of the population
%                     after mutation in the same format as OldChrom.


function NewChrom = mutate_tsp(MUT_F, OldChrom, PR_MUT, SUBPOP)

% Check parameter consistency
if nargin < 2; error('Not enough input parameters'); end

% Probability of mutation
if nargin < 3; PR_MUT = 0.05; end

% Population size
[rows, cols] = size(OldChrom);
NewChrom = zeros(rows, cols);

if nargin < 4; SUBPOP = 1;
elseif nargin > 3
  if isempty(SUBPOP), SUBPOP = 1;
  elseif isnan(SUBPOP), SUBPOP = 1;
  elseif length(SUBPOP) ~= 1, error('SUBPOP must be a scalar'); 
  end
end

if (rows/SUBPOP) ~= fix(rows/SUBPOP)
    error('OldChrom and SUBPOP disagree'); 
end

rows = rows/SUBPOP;  % Compute number of individuals per subpopulation

% Select individuals of subpopulations and call low level function
for subpop = 1:SUBPOP
    SubChrom = OldChrom((subpop-1)*rows+1:subpop*rows,:);
    
    for row = 1:rows
        if rand < PR_MUT
            NewChrom((subpop-1)*rows + row, :) = feval(MUT_F, SubChrom(row, :));
        else
            NewChrom((subpop-1)*rows + row, :) = SubChrom(row, :);
        end
    end
end

end