% SEL_TOURNAMENT.m (TOURNAMENT SELECTION)
%
% This function performs tournament selection.
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - number of individuals to be selected
%
% Output parameter:
%    NewChrIx  - column vector containing the indexes of the selected
%                individuals relative to the original population, shuffled.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(NewChrIx,:).

function NewChrIx = sel_tournament(FitnV, NSel)

NewChrIx = zeros(NSel, 1);

[NInd, ~] = size(FitnV);

k = max(2, floor(0.05*NInd));

for i = 1:NSel
    randIdx = randi(NInd, [k, 1]);
    [~, I] = max(FitnV(randIdx));
    NewChrIx(i) = randIdx(I);
end

end

