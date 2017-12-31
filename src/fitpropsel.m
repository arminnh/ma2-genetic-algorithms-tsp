% FITPROPSEL.m (FITNESS PROPORTIONAL SELECTION)
%
% This function performs fitness proportional selection.
%
% Syntax:  NewChrIx = tournament(FitnV, NSel)
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - number of individuals to be selected
%
% Output parameters:
%    NewChrIx  - column vector containing the indexes of the selected
%                individuals relative to the original population, shuffled.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(NewChrIx,:).

function NewChrIx = fitpropsel(FitnV, NSel)

NewChrIx = zeros(NSel, 1);

fitSum = sum(FitnV);
[selProp, I] = sort(FitnV / fitSum);

for i = 1:NSel
    s = find(cumsum(selProp) >= rand, 1, 'first');
    NewChrIx(i) = I(s);
end

end

