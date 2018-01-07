NIND=800;		% Number of individuals
MAXGEN=250;		% Maximum no. of generations
ELITIST=0.05;    % percentage of the elite population
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'cross_alternating_edges';  % default crossover operator
MUTATION = 'mut_inversion'; % mutation operators
SELECTION = 'sus';
% Gets handled by the loop
% SUBPOP = 1;         % Amount of subpopulations

SCALING = 1;        % City location scaling on/off
RUNS = 10;          % Number of ga runs in tests
CUSTOMSTOP = 1;     % Custom stopping criterion on/off
CUSTOMSS = 0;       % Custom survivor selection on/off

datasetslist = dir('datasets/');
Ndatasets = size(datasetslist, 1) - 2;

out = fopen('../report/task7c_results.tex', 'w');
fprintf(out, 'A & B & C & D & E\n\\midrule\n');
results = zeros([Ndatasets 4]);
for SUBPOP = [1 2 5 10 20]
    for ds = 1:Ndatasets
        datasetslist(ds + 2).name
        data = load(['datasets/' datasetslist(ds + 2).name]);
        x = data(:,1) / max([data(:,1); data(:,2)]); 
        y = data(:,2) / max([data(:,1); data(:,2)]);
        NVAR=size(data,1);

        for i = 1:RUNS
            [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
            Ngen = find(best, 1, 'last');
            B = best(Ngen);
            M = mean(Ngen);
            W = worst(Ngen);

            results(ds, :) = results(ds, :) + [Ngen B M W];
        end

        results(ds, :) = results(ds, :) / RUNS;

        fprintf(out, '%s & %.1f & %.4f & %.4f & %.4f \\\\\n', datasetslist(ds + 2).name, results(ds, 1) - 1, results(ds, 2), results(ds, 3), results(ds, 4));

    end
    
    fprintf(out, '\n\n\n')
end

fclose(out);

results