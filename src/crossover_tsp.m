% CROSSOVER_TSP.M (Crossover for TSP high-level function)
%
% This function performs recombination (crossover) between pairs of 
% individuals and returns the new individuals after mating. 
% The function handles multiple populations and calls a given low-level 
% function for the actual recombination process.
%
% Input parameters:
%    CROSS_F        - String containing the name of the crossover function
%    OldChrom       - Matrix containing the chromosomes of the old
%                     population. Each line corresponds to one individual
%    Representation - The TSP representation the given population is in.
%    PR_CROSS       - (optional) Scalar containing the probability of 
%                     recombination/crossover occurring between pairs
%                     of individuals. If omitted or NaN, 0.95 is assumed.
%    SUBPOP         - (optional) Number of subpopulations. 
%                     If omitted or NaN, 1 subpopulation is assumed.
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after recombination in the same format as OldChrom.

function NewChrom = crossover_tsp(CROSS_F, OldChrom, Representation, PR_CROSS, SUBPOP)

% Check parameter consistency
if nargin < 3, error('Not enough input parameter'); end

% Probability of crossover
if nargin < 4, PR_CROSS = 0.95;
elseif nargin > 3
  if isempty(PR_CROSS), PR_CROSS = 0.7;
  elseif isnan(PR_CROSS), PR_CROSS = 0.7;
  elseif length(PR_CROSS) ~= 1, error('PR_CROSS must be a scalar');
  elseif (PR_CROSS < 0 | PR_CROSS > 1), error('PR_CROSS must be a scalar in [0, 1]'); 
  end
end

% Population size
[rows, cols] = size(OldChrom);
maxrows = rows;
if rem(rows, 2) ~= 0
   maxrows = maxrows - 1;
end
NewChrom = zeros(maxrows, cols);

if nargin < 5, SUBPOP = 1;
elseif nargin > 4
  if isempty(SUBPOP), SUBPOP = 1;
  elseif isnan(SUBPOP), SUBPOP = 1;
  elseif length(SUBPOP) ~= 1, error('SUBPOP must be a scalar'); 
  end
end

if (maxrows/SUBPOP) ~= fix(maxrows/SUBPOP)
    error('OldChrom and SUBPOP disagree'); 
end
maxrows = maxrows/SUBPOP;  % Compute number of individuals per subpopulation

% Select individuals of subpopulations and call low level function
for subpop = 1:SUBPOP
    SubChrom = OldChrom((subpop-1)*maxrows+1:subpop*maxrows, :);

    for row = 1:2:maxrows
        if rand < PR_CROSS
            % TODO: adapt crossover functions so that feval can be used
            % with all of them
            if strcmp(CROSS_F, 'cross_alternate_edges')
                NewChrom(row,:) = cross_alternate_edges([ SubChrom(row,:) ; SubChrom(row+1,:) ]);
                NewChrom(row+1,:) = cross_alternate_edges([ SubChrom(row+1,:) ; SubChrom(row,:) ]);
            else 
                [ChildOne, ChildTwo] = feval(CROSS_F, SubChrom(row, :), SubChrom(row+1, :), Representation);
                NewChrom((subpop-1)*maxrows + row, :) = ChildOne;
                NewChrom((subpop-1)*maxrows + row + 1, :) = ChildTwo;
            end
        else
            NewChrom((subpop-1)*maxrows + row, :) = SubChrom(row, :);
            NewChrom((subpop-1)*maxrows + row + 1, :) = SubChrom(row+1, :);
        end
    end
end

if rem(rows, 2) ~= 0
   NewChrom(rows, :) = OldChrom(rows, :);
end

end
