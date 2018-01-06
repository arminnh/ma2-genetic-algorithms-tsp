NIND=100;		% Number of individuals
MAXGEN=250;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.05;    % percentage of the elite population
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
% Gets handled by the loop
% LOCALLOOP=0;      % local loop removal
CROSSOVER = 'cross_alternating_edges';  % default crossover operator
MUTATION = 'mut_inversion'; % mutation operators
SELECTION='sus';
SUBPOP = 1;         % Amount of subpopulations

SCALING = 1;        % City location scaling on/off
RUNS = 10;          % Number of ga runs in tests
CUSTOMSTOP = 0;     % Custom stopping criterion on/off
CUSTOMSS = 0;       % Custom survivor selection on/off

datasetslist = dir('datasets/');
Ndatasets = size(datasetslist, 1) - 2;

results = zeros([Ndatasets 4 2]);

out = fopen('../report/task5_results.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr c rrrr} \n\\toprule\n');
fprintf(out, '& \\multicolumn{4}{c}{Local optimisation disabled} & \\phantom{abc} & \\multicolumn{4}{c}{Local optimisation enabled}\\\\\n');
fprintf(out, '\\cmidrule{2-5} \\cmidrule{7-10}\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max && \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');

for LOCALLOOP = 0:1
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

            results(ds, :, LOCALLOOP + 1) = results(ds, :, LOCALLOOP + 1) + [Ngen B M W];
        end

        results(ds, :, LOCALLOOP + 1) = results(ds, :, LOCALLOOP + 1) / RUNS;

    end
end

for ds = 1:Ndatasets
    fprintf(out, '%s & %.1f & %.4f & %.4f & %.4f && %.1f & %.4f & %.4f & %.4f \\\\\n', datasetslist(ds + 2).name, results(ds, 1, 1), results(ds, 2, 1), results(ds, 3, 1), results(ds, 4, 1), results(ds, 1, 2), results(ds, 2, 2), results(ds, 3, 2), results(ds, 4, 2));
end

fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Comparison between local optimisation disabled (left) and local optimisation enabled (right).}\n');
fprintf(out, '\\label{tab:localopt}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

results