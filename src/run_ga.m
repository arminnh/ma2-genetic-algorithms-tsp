% run_ga.m (RUN GENETIC ALGORITHM)
% 
% Input parameters:
%   x, y            - coordinates of the cities
%   NIND            - number of individuals
%   MAXGEN          - maximal number of generations
%   ELITIST         - percentage of elite population
%   STOP_PERCENTAGE - percentage of equal fitness (stop criterium)
%   PR_CROSS        - probability for crossover
%   PR_MUT          - probability for mutation
%   CROSSOVER       - the crossover operator
%   MUTATION        - the mutation operator
%   LOCALLOOP       - local loop removal on/off
%   CUSTOMSTOP      - custom stopping criterion on/off
%   CUSTOMSS        - custom survivor selection on/off
%   SELECTION       - the parent selection function (sus, sel_tournament,
%                     sel_fit_prop, ...)
%   ah1, ah2, ah3   - axes handles to visualise tsp
%
% Output parameters:
%   best            - vector of the best result of every iteration
%   mean_fits       - vector of the mean result of every iteration
%   worst           - vector of the worst result of every iteration

function [best, mean_fits, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP, ah1, ah2, ah3)

    GGAP = 1 - ELITIST;
    
    best = zeros(1, MAXGEN);
    mean_fits = zeros(1,MAXGEN+1);
    worst = zeros(1,MAXGEN+1);
    
    Dist = zeros(NVAR,NVAR);
    for i = 1:size(x,1)
        for j = 1:size(y,1)
            Dist(i,j) = sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end
    
    % initialize population
    Chrom = zeros(NIND,NVAR);
    for row = 1:NIND
        Chrom(row,:) = path2adj(randperm(NVAR));
    end
    % evaluate initial population
    ObjV = tspfun(Chrom, Dist);
    
    % number of individuals of equal fitness needed to stop
    stopN = ceil(STOP_PERCENTAGE*NIND);

    gen = 0;
    % generational loop
    while gen < MAXGEN
        sObjV = sort(ObjV);
        best(gen+1) = min(ObjV);
        minimum = best(gen+1);
        mean_fits(gen+1) = mean(ObjV);
        worst(gen+1) = max(ObjV);
        for t = 1:size(ObjV,1)
            if (ObjV(t) == minimum)
                break;
            end
        end

        if nargin == 19
            visualizeTSP(x, y, adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
        end
        
        % stopping criterion: stop when the minimum of the last stopN
        % generations has not improved
        if CUSTOMSTOP == 1
            if (gen-0.1*MAXGEN > 1) && ((best(floor(gen-0.1*MAXGEN)) - minimum) <= 1e-15)
                break;
            end  
        else
            if (sObjV(stopN)-sObjV(1) <= 1e-15)
                break;
            end
        end

        % assign fitness values to entire population
        FitnV = ranking(ObjV);
        
        % select individuals for breeding
        SelCh = select(SELECTION, Chrom, FitnV, GGAP);
        
        %recombine individuals (crossover)
        SelCh = crossover_tsp(CROSSOVER, SelCh, PR_CROSS, SUBPOP);
        SelCh = mutate_tsp(MUTATION, SelCh, PR_MUT, SUBPOP);        
        
        %evaluate offspring, call objective function
        ObjVSel = tspfun(SelCh, Dist);
        
        %reinsert offspring into population
        if CUSTOMSS == 0
            [Chrom, ObjV] = reins(Chrom, SelCh, SUBPOP, 1, ObjV, ObjVSel);
        else
            [Chrom, ObjV] = sur_sel_rr_tournament(Chrom, SelCh, ObjV, ObjVSel, 10);
        end
        
        Chrom = tsp_improve_population(NIND, NVAR, Chrom, LOCALLOOP, Dist);
        
        gen = gen+1;            
    end
end
