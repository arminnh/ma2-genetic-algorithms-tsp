% REINS.M        (RE-INSertion of offspring in population replacing parents)
%
% This function reinserts offspring in the population.
%
% Syntax: [Chrom, ObjVCh] = reins(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel)
%
% Input parameters:
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    SelCh     - Matrix containing the offspring of the current
%                population. Each row corresponds to one individual.
%    SUBPOP    - (optional) Number of subpopulations
%                if omitted or NaN, 1 subpopulation is assumed
%    InsOpt    - (optional) Vector containing the insertion method parameters
%                ExOpt(1): Select - number indicating kind of insertion
%                          0 - uniform insertion
%                          1 - fitness-based insertion
%                          if omitted or NaN, 0 is assumed
%                ExOpt(2): INSR - Rate of offspring to be inserted per
%                          subpopulation (% of subpopulation)
%                          if omitted or NaN, 1.0 (100%) is assumed
%    ObjVCh    - (optional) Column vector containing the objective values
%                of the individuals (parents - Chrom) in the current 
%                population, needed for fitness-based insertion
%                saves recalculation of objective values for population
%    ObjVSel   - (optional) Column vector containing the objective values
%                of the offspring (SelCh) in the current population, needed for
%                partial insertion of offspring,
%                saves recalculation of objective values for population
%
% Output parameters:
%    Chrom     - Matrix containing the individuals of the current
%                population after reinsertion.
%    ObjVCh    - if ObjVCh and ObjVSel are input parameter, than column 
%                vector containing the objective values of the individuals
%                of the current generation after reinsertion.
           
% Author:     Hartmut Pohlheim
% History:    10.03.94     file created
%             19.03.94     parameter checking improved

function [Chrom, ObjVCh] = sstournament(Chrom, SelCh, ObjVCh, ObjVSel, q)
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
