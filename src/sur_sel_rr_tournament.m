% SUR_SEL_RR_TOURNAMENT.M (ROUND ROBIN TOURNAMENT SURVIVOR SELECTION)
%
% Reinserts offspring in the population by round-robin tournament 
% survivor selection.
%
% Input parameters:
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    SelCh     - Matrix containing the offspring of the current population. 
%                Each row corresponds to one individual.
%    ObjVCh    - Column vector containing the objective values of the 
%                individuals (parents - Chrom) in the current population, 
%                needed for fitness-based insertion saves recalculation of 
%                objective values for population
%    ObjVSel   - Column vector containing the objective values of the 
%                offspring (SelCh) in the current population, needed for
%                partial insertion of offspring, saves recalculation of 
%                objective values for population
%    q         - The amount of other individuals that each individual is
%                to be evaluated against
%
% Output parameters:
%    Chrom     - Matrix containing the individuals of the current
%                population after reinsertion.
%    ObjVCh    - if ObjVCh and ObjVSel are input parameter, than column 
%                vector containing the objective values of the individuals
%                of the current generation after reinsertion.

function [Chrom, ObjVCh] = sur_sel_rr_tournament(Chrom, SelCh, ObjVCh, ObjVSel, q)

pop = [Chrom; SelCh];
popFit = [ObjVCh; ObjVSel];
[Npop, ~] = size(pop);
[NIND, ~] = size(Chrom);
wins = zeros(Npop, 1);

for i = 1:Npop
    wins(i) = sum(popFit(i) >= popFit(randi(Npop, [q 1])));
end

[~, I] = sort(wins);

Chrom = pop(I(1:NIND), :);
ObjVCh = popFit(I(1:NIND));

end
