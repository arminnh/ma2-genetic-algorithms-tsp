NIND=50;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.05;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'cross_alternating_edges';  % default crossover operator
SELECTION = 'sus';
SUBPOP = 1;         % Amount of subpopulations

SCALING = 1;        % City location scaling on/off
RUNS = 2;          % Number of ga runs in tests
CUSTOMSTOP = 0;     % Custom stopping criterion on/off
CUSTOMSS = 1;       % Custom survivor selection on/off

datasetslist = dir('datasets/');
Ndatasets = size(datasetslist, 1) - 2;

results = zeros([Ndatasets 4]);

out = fopen('./table.tex', 'w');
fprintf(out, 'A & B & C & D & E\n\\midrule\n');

for ds = 1:Ndatasets
    datasetslist(ds + 2).name
    data = load(['datasets/' datasetslist(ds + 2).name]);
    
    x = data(:,1);
    y = data(:,2);
    
    if SCALING == 1
        x = x / max([data(:,1); data(:,2)]);
        y = y / max([data(:,1); data(:,2)]);
    end
    
    NVAR=size(data,1);
    
    for i = 0:RUNS
        [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, 'mut_inversion', LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
        Ngen = find(best, 1, 'last');
        B = best(Ngen);
        M = mean(Ngen);
        W = worst(Ngen);
        
        results(ds, :) = results(ds, :) + [Ngen B M W];
    end
    
    results(ds, :) = results(ds, :) / RUNS;

    fprintf(out, '%s & %d & %d & %d & %d \\\\\n', datasetslist(ds + 2).name, results(ds, 1) - 1, results(ds, 2), results(ds, 3), results(ds, 4));
    
end

fclose(out);

results