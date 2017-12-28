function [best, mean_fits, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, ah1, ah2, ah3)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
% {NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT CROSSOVER LOCALLOOP}

    % TODO: add option to select representation in gui
    % 1: adjacency representation, 2: path representation
    representation = 2;
    % TODO: add option for parent selection in gui
    SELECTION = 'sus';
    SELECTION = 'tournament';
    SELECTION = 'fitpropsel';
    
    SUBPOP = 1;
    
    GGAP = 1 - ELITIST;
    mean_fits = zeros(1,MAXGEN+1);
    worst = zeros(1,MAXGEN+1);
    Dist = zeros(NVAR,NVAR);
    for i = 1:size(x,1)
        for j = 1:size(y,1)
            Dist(i,j) = sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end
    % initialize population
    % TODO: adapt other functions so that we don't need to convert representations manually?
    Chrom = zeros(NIND,NVAR);
    for row = 1:NIND
        %if (representation == 1)
            Chrom(row,:) = path2adj(randperm(NVAR));
        %else 
        %    Chrom(row,:) = randperm(NVAR);
        %end
    end
    gen = 0;
    % number of individuals of equal fitness needed to stop
    stopN = ceil(STOP_PERCENTAGE*NIND);
    % evaluate initial population
    ObjV = tspfun(Chrom, Dist);
    best=zeros(1, MAXGEN);

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

        if nargin == 15
            visualizeTSP(x, y, adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
        end
        
        % stopping criterion: stop when the minimum of the last X%
        % generations has not improved
        if CUSTOMSTOP == 1
            if ((gen-0.1*MAXGEN > 1) && ((best(floor(gen-0.1*MAXGEN:gen)) - minimum) <= 1e-15))
                break;
            end  
        else
            if (sObjV(stopN)-sObjV(1) <= 1e-15)
                break;
            end
        end

        
        %assign fitness values to entire population
        FitnV = ranking(ObjV);
        
        %select individuals for breeding
        SelCh = select(SELECTION, Chrom, FitnV, GGAP);
        
        %recombine individuals (crossover)
        if (representation == 1) 
            SelCh = recombin(CROSSOVER, SelCh, PR_CROSS, SUBPOP);
            SelCh = mutateTSP('inversion', SelCh, PR_MUT, representation, SUBPOP);
        else 
            [selX, ~] = size(SelCh);
            for i = 1:selX
                SelCh(i, :) = adj2path(SelCh(i, :));
            end
            
            SelCh = recombin('cross_order', SelCh, PR_CROSS, SUBPOP);
            SelCh = mutateTSP('inversion', SelCh, PR_MUT, representation, SUBPOP);
            
            for i = 1:selX
                SelCh(i, :) = path2adj(SelCh(i, :));
            end
        end
        %evaluate offspring, call objective function
        ObjVSel = tspfun(SelCh, Dist);
        %reinsert offspring into population
        
        if CUSTOMSS == 0
            [Chrom, ObjV] = reins(Chrom, SelCh, SUBPOP, 1, ObjV, ObjVSel);
        else
            [Chrom, ObjV] = sstournament(Chrom, SelCh, ObjV, ObjVSel, 10);
        end
        
        Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom, LOCALLOOP, Dist);
        %increment generation counter
        gen = gen+1;            
    end
end
