% Number of individuals
NIND=50;	
% Maximum no. of generations
MAXGEN=100;
% percentage of the elite population
ELITIST=0.05;    
% Generation gap
GGAP=1-ELITIST;		
% percentage of equal fitness individuals for stopping
STOP_PERCENTAGE=.95;    
% probability of crossover
PR_CROSS=.95;     
% probability of mutation
PR_MUT=.05;       
% local loop removal
LOCALLOOP=0;   
% crossover operators
CROSSOVER = ["cross_alternating_edges", "cross_order"];     
% mutation operators
MUTATION = ["mut_inversion", "mut_inversion2"];
% parent selection algorithm
SELECTION = 'sus';
% Amount of subpopulations
SUBPOP = 1;
% City location scaling on/off
SCALING = 1;        
% Custom stopping criterion on/off
CUSTOMSTOP = 0;     
% Custom survivor selection on/off
CUSTOMSS = 0;       

% Number of ga runs in tests
RUNS = 10;          

datasetslist = dir('datasets/');
Ndatasets = size(datasetslist, 1) - 2;

out = fopen('../report/task4_crossover.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr c rrrr} \n\\toprule\n');
fprintf(out, '& \\multicolumn{4}{c}{Alternating Edge Crossover} & \\phantom{abc} & \\multicolumn{4}{c}{Order Crossover}\\\\\n');
fprintf(out, '\\cmidrule{2-5} \\cmidrule{7-10}\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max && \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
results = zeros([Ndatasets 4 2]);
for ds = 1:Ndatasets
    fprintf('crossover %s\n', datasetslist(ds + 2).name)
    data = load(['datasets/' datasetslist(ds + 2).name]);
    x = data(:,1); y = data(:,2);
    if SCALING == 1; x = x / max([data(:,1); data(:,2)]); y = y / max([data(:,1); data(:,2)]); end
    NVAR=size(data,1);
    
    for c = 1:length(CROSSOVER)
        for i = 0:RUNS
            [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER(c), 'mut_inversion', LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
            Ngen = find(best, 1, 'last'); B = best(Ngen); M = mean(Ngen); W = worst(Ngen);
            results(ds, :, c) = results(ds, :, c) + [Ngen B M W];
        end
        results(ds, :, c) = results(ds, :, c) / RUNS;
    end
    fprintf(out, '%s & %.1f & %.2f & %.2f & %.2f && %.1f & %.2f & %.2f & %.2f \\\\\n', datasetslist(ds + 2).name, results(ds, 1, 1), results(ds, 2, 1), results(ds, 3, 1), results(ds, 4, 1), results(ds, 1, 2), results(ds, 2, 2), results(ds, 3, 2), results(ds, 4, 2));
end
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Results of different crossover functions.}\n');
fprintf(out, '\\label{tab:path_repr_crossover}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

out = fopen('../report/task4_mutation.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr c rrrr} \n\\toprule\n');
fprintf(out, '& \\multicolumn{4}{c}{Simple Inversion Mutation} & \\phantom{abc} & \\multicolumn{4}{c}{Inversion Mutation}\\\\\n');
fprintf(out, '\\cmidrule{2-5} \\cmidrule{7-10}\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max && \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
results = zeros([Ndatasets 4 2]);
for ds = 1:Ndatasets
    fprintf('mutation %s\n', datasetslist(ds + 2).name)
    data = load(['datasets/' datasetslist(ds + 2).name]);
    x = data(:,1); y = data(:,2);
    if SCALING == 1; x = x / max([data(:,1); data(:,2)]); y = y / max([data(:,1); data(:,2)]); end
    NVAR=size(data,1);
    
    for m = 1:length(MUTATION)
        for i = 0:RUNS
            [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, 'cross_alternating_edges', MUTATION(m), LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
            Ngen = find(best, 1, 'last'); B = best(Ngen); M = mean(Ngen); W = worst(Ngen);
            results(ds, :, m) = results(ds, :, m) + [Ngen B M W];
        end
        results(ds, :, m) = results(ds, :, m) / RUNS;
    end
    fprintf(out, '%s & %.1f & %.2f & %.2f & %.2f && %.1f & %.2f & %.2f & %.2f \\\\\n', datasetslist(ds + 2).name, results(ds, 1, 1), results(ds, 2, 1), results(ds, 3, 1), results(ds, 4, 1), results(ds, 1, 2), results(ds, 2, 2), results(ds, 3, 2), results(ds, 4, 2));
end
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Results of different mutation functions.}\n');
fprintf(out, '\\label{tab:path_repr_mutation}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

out = fopen('../report/task4_tuning.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
results = zeros([Ndatasets 4]);
for ds = 1:Ndatasets
    fprintf('tuning %s\n', datasetslist(ds + 2).name)
    data = load(['datasets/' datasetslist(ds + 2).name]);
    x = data(:,1); y = data(:,2);
    if SCALING == 1; x = x / max([data(:,1); data(:,2)]); y = y / max([data(:,1); data(:,2)]); end
    NVAR=size(data,1);
    
    for i = 0:RUNS
        [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, 'cross_order', 'mut_inversion2', LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
        Ngen = find(best, 1, 'last'); B = best(Ngen); M = mean(Ngen); W = worst(Ngen);
        results(ds, :) = results(ds, :) + [Ngen B M W];
    end
    results(ds, :) = results(ds, :) / RUNS;
    fprintf(out, '%s & %.1f & %.2f & %.2f & %.2f \\\\\n', datasetslist(ds + 2).name, results(ds, 1), results(ds, 2), results(ds, 3), results(ds, 4));
end
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Results with operators for path representation after parameter tuning.}\n');
fprintf(out, '\\label{tab:path_repr_tuning}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);