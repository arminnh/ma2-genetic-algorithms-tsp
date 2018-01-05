NIND=50;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.05;    % percentage of the elite population
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'cross_alternating_edges';  % default crossover operator
MUTATION = 'mut_inversion'; % mutation operators
% Gets handled by the loop
% SELECTION = 'sus';
SUBPOP = 1;         % Amount of subpopulations

SCALING = 1;        % City location scaling on/off
RUNS = 10;          % Number of ga runs in tests

CUSTOMSTOP = 0;     % Custom stopping criterion on/off
CUSTOMSS = 0;       % Custom survivor selection on/off

datasetslist = dir('datasets/');
Ndatasets = size(datasetslist, 1) - 2;

results = zeros([Ndatasets 4 3]);

out = fopen('./tableparentsel.tex', 'w');
fprintf(out, 'A & B & C & D & E\n\\midrule\n');

for selectionidx = 1:3
    SELECTION = '';
    if selectionidx == 1
        SELECTION = 'sus';
    elseif selectionidx == 2
        SELECTION = 'sel_tournament';
    elseif selectionidx == 3
        SELECTION = 'sel_fit_prop';
    end
    
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
            [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
            Ngen = find(best, 1, 'last');
            B = best(Ngen);
            M = mean(Ngen);
            W = worst(Ngen);

            results(ds, :, selectionidx) = results(ds, :, selectionidx) + [Ngen B M W];
        end

        results(ds, :, selectionidx) = results(ds, :, selectionidx) / RUNS;

        fprintf(out, '%s & %.1f & %.4f & %.4f & %.14f \\\\\n', datasetslist(ds + 2).name, results(ds, 1, selectionidx), results(ds, 2, selectionidx), results(ds, 3, selectionidx), results(ds, 4, selectionidx));

    end
end

fclose(out);

results