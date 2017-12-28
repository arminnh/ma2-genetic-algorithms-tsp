% MUTATETSP.M       (MUTATion for TSP high-level function)
%
% This function takes a matrix OldChrom containing the 
% representation of the individuals in the current population,
% mutates the individuals and returns the resulting population.
%
% Syntax:  NewChrom = mutate(MUT_F, OldChrom, MutOpt)
%
% Input parameter:
%    MUT_F     - String containing the name of the mutation function
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual.
%    MutOpt    - mutation rate
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mutation in the same format as OldChrom.


function NewChrom = mutateTSP(MUT_F, OldChrom, MutOpt, Representation, SUBPOP)

% Check parameter consistency
if nargin < 4,  error('Not enough input parameters'); end

[Nind, ~] = size(OldChrom);
Nind = Nind / SUBPOP;

NewChrom = OldChrom;
for irun = 1:SUBPOP
    ChromSub = OldChrom((irun-1)*Nind+1:irun*Nind,:);
    [irows, ~] = size(ChromSub);
    for r = 1:irows
        if rand < MutOpt
            NewChrom(r,:) = feval(MUT_F, ChromSub(r,:), Representation);
        end
    end
end
% End of function