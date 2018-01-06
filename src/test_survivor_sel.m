NIND=100;            % Number of individuals
MAXGEN=250;          % Maximum no. of generations
STOP_PERCENTAGE=.95; % percentage of equal fitness individuals for stopping
PR_CROSS=.95;        % probability of crossover
PR_MUT=.05;          % probability of mutation
LOCALLOOP=0;         % local loop removal
CROSSOVER = 'cross_alternating_edges'; % crossover operator
MUTATION = 'mut_inversion'; % mutation operator
SELECTION = 'sus';   % parent selection algorithm
SUBPOP = 1;          % Amount of subpopulations
CUSTOMSTOP = 1;      % Custom stopping criterion on/off
RUNS = 10;           % Number of ga runs in tests

ELITIST=[0 0.30];    % percentage of the elite population
CUSTOMSS = [1 1];    % Custom survivor selection on/off

datasetslist = dir('datasets/');
Ndatasets = size(datasetslist, 1) - 2;

out = fopen('../report/task7b.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr c rrrr} \n\\toprule\n');
fprintf(out, '& \\multicolumn{4}{c}{Round robin tournament} & \\phantom{abc} & \\multicolumn{4}{c}{Elitism + round robin tournament}\\\\\n');
fprintf(out, '\\cmidrule{2-5} \\cmidrule{7-10}\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max && \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
results = zeros([Ndatasets 4 2]);
for ds = 1:Ndatasets
    fprintf('%s\n', datasetslist(ds + 2).name)
    data = load(['datasets/' datasetslist(ds + 2).name]);
    x = data(:,1) / max([data(:,1); data(:,2)]); 
    y = data(:,2) / max([data(:,1); data(:,2)]);
    NVAR=size(data,1);
    
    for c = 1:length(ELITIST)
        for i = 1:RUNS
            [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST(c), STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS(c), SELECTION, SUBPOP);
            Ngen = find(best, 1, 'last'); B = best(Ngen); M = mean(Ngen); W = worst(Ngen);
            results(ds, :, c) = results(ds, :, c) + [Ngen B M W];
        end
        results(ds, :, c) = results(ds, :, c) / RUNS;
    end
    fprintf(out, '%s & %.1f & %.2f & %.2f & %.2f && %.1f & %.2f & %.2f & %.2f \\\\\n', datasetslist(ds + 2).name, results(ds, 1, 1), results(ds, 2, 1), results(ds, 3, 1), results(ds, 4, 1), results(ds, 1, 2), results(ds, 2, 2), results(ds, 3, 2), results(ds, 4, 2));
end
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Results for the already implemented elitism and our round robin tournament survivor selection.}\n');
fprintf(out, '\\label{tab:survivor_selection}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);