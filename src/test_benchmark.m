NIND=1000;           % Number of individuals
MAXGEN=1000;         % Maximum no. of generations
ELITIST=0.05;        % percentage of the elite population
STOP_PERCENTAGE=.95; % percentage of equal fitness individuals for stopping
PR_CROSS=.50;        % probability of crossover
PR_MUT=.30;          % probability of mutation
LOCALLOOP=1;         % local loop removal
CROSSOVER = 'cross_order'; % crossover operators
MUTATION = 'mut_inversion'; % mutation operators
SELECTION = 'sel_tournament'; % parent selection algorithm
SUBPOP = 1;          % Amount of subpopulations
CUSTOMSTOP = 0;      % Custom stopping criterion on/off
CUSTOMSS = 1;        % Custom survivor selection on/off
RUNS = 5;            % Number of ga runs in tests

datasetslist = dir('tsp-benchmark-problems/');
Ndatasets = size(datasetslist, 1) - 2;
%BCL380: 1621, belgiumtour: ???, RBX711: 3115, XQF131: 564, XQL662: 2513
lengths = [0 0 1621 1 3115 564 2513];

out = fopen('../report/task6_benchmark2.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrrr c rrr} \n\\toprule\n');
fprintf(out, 'Dataset & Optimal length & \\# Generations & Min & Mean & Max && Error Min & Error Mean & Error Max\\\\ \n\\midrule\n');
results = Inf([Ndatasets 4]);
for ds = 1:Ndatasets
    data = load(['tsp-benchmark-problems/' datasetslist(ds + 2).name]);
    x = data(:,1); 
    y = data(:,2);
    NVAR = size(data,1);
    
    for i = 1:RUNS
        fprintf('%s run %i\n', datasetslist(ds + 2).name, i)
        [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
        Ngen = find(best, 1, 'last'); B = best(Ngen); M = mean(Ngen); W = worst(Ngen);
        if (results(ds, 2) > B)
            fprintf('%s run %i, found lower minimum %i\n', datasetslist(ds + 2).name, i, B)
            results(ds, :) = [Ngen B M W];
        end
    end
    
    l = lengths(ds + 2);
    fprintf(out, '%s & %i & %.1f & %.2f & %.2f & %.2f && %.2f\\%% & %.2f\\%% & %.2f\\%% \\\\\n', datasetslist(ds + 2).name, l, results(ds, 1), results(ds, 2), results(ds, 3), results(ds, 4), 100*abs(l-results(ds, 2))/l, 100*abs(l-results(ds, 3))/l, 100*abs(1-results(ds, 4))/l);
end
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Results for benchmark problems with our final algorithm.}\n');
fprintf(out, '\\label{tab:benchmark}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);