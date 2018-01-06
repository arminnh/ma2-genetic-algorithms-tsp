NIND=1000;           % Number of individuals
MAXGEN=1000;         % Maximum no. of generations
ELITIST=0;           % percentage of the elite population
STOP_PERCENTAGE=.95; % percentage of equal fitness individuals for stopping
PR_CROSS=.5;         % probability of crossover
PR_MUT=.3;           % probability of mutation
LOCALLOOP=1;         % local loop removal
CROSSOVER = 'cross_order'; % crossover operators
MUTATION = 'mut_inversion'; % mutation operators
SELECTION = 'sel_tournament'; % parent selection algorithm
SUBPOP = 1;          % Amount of subpopulations
CUSTOMSTOP = 1;      % Custom stopping criterion on/off
CUSTOMSS = 1;        % Custom survivor selection on/off
RUNS = 10;           % Number of ga runs in tests

datasetslist = dir('datasets/');
Ndatasets = size(datasetslist, 1) - 2;

out = fopen('../report/task4_tuning.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
results = zeros([Ndatasets 4]);
for ds = 1:Ndatasets
    fprintf('tuning %s\n', datasetslist(ds + 2).name)
    data = load(['datasets/' datasetslist(ds + 2).name]);
    x = data(:,1) / max([data(:,1); data(:,2)]); 
    y = data(:,2) / max([data(:,1); data(:,2)]);
    NVAR=size(data,1);
    
    for i = 1:RUNS
        [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
        Ngen = find(best, 1, 'last'); B = best(Ngen); M = mean(Ngen); W = worst(Ngen);
        results(ds, :) = results(ds, :) + [Ngen B M W];
    end
    results(ds, :) = results(ds, :) / RUNS;
    fprintf(out, '%s & %.1f & %.2f & %.2f & %.2f \\\\\n', datasetslist(ds + 2).name, results(ds, 1), results(ds, 2), results(ds, 3), results(ds, 4));
end
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Results for operators for path representation after parameter tuning.}\n');
fprintf(out, '\\label{tab:path_repr_tuning}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);