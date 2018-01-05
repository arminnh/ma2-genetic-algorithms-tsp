NIND=[50 100 250 500 1000];
MAXGEN=[100 250 500 1000];
ELITIST=[0 0.05 0.10 0.30 0.50 0.70 0.95];
STOP_PERCENTAGE=.95;
PR_CROSS=[0 0.10 0.30 0.50 0.70 .95];
PR_MUT=[0 .05 0.10 0.30 0.50 0.70 0.95];
LOCALLOOP=0;
CROSSOVER = 'cross_alternating_edges'; 
MUTATION = 'mut_inversion';
SELECTION = 'sus';
SUBPOP = 1;
SCALING = 1;   
CUSTOMSTOP = 0;
CUSTOMSS = 0;
RUNS = 10;

datasetslist = dir('datasets/');
datasetslist = datasetslist([1 2 3 7 10 13]);
%datasetslist = datasetslist([1 2 3]);

out = fopen('../report/task2_individuals.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
for x = NIND
    fprintf('nind = %i\n', x)
    fprintf(out, '\\multicolumn{5}{c}{number of individuals = %i}\\\\ \n\\midrule\n', x);
    test_run(datasetslist, out, SCALING, RUNS, x, MAXGEN(2), ELITIST(2), STOP_PERCENTAGE, PR_CROSS(6), PR_MUT(2), CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
    if x ~= NIND(end); fprintf(out, '\\midrule\n'); end
end		
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm with varying amount of individuals.}\n');
fprintf(out, '\\label{tab:vary_ind}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

out = fopen('../report/task2_generations.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
for x = MAXGEN
    fprintf('maxgen = %i\n', x)
    fprintf(out, '\\multicolumn{5}{c}{max number of generations = %i}\\\\ \n\\midrule\n', x);
    test_run(datasetslist, out, SCALING, RUNS, NIND(2), x, ELITIST(2), STOP_PERCENTAGE, PR_CROSS(6), PR_MUT(2), CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
    if x ~= MAXGEN(end); fprintf(out, '\\midrule\n'); end
end		
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm with varying amount of maximum generations.}\n');
fprintf(out, '\\label{tab:vary_gen}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

out = fopen('../report/task2_elitism.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
for x = ELITIST
    fprintf('elitist = %i\n', x)
    fprintf(out, '\\multicolumn{5}{c}{percentage of the elite population = %.2f}\\\\ \n\\midrule\n', x);
    test_run(datasetslist, out, SCALING, RUNS, NIND(2), MAXGEN(2), x, STOP_PERCENTAGE, PR_CROSS(6), PR_MUT(2), CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
    if x ~= ELITIST(end); fprintf(out, '\\midrule\n'); end
end		
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm with varying percentage of the elite population.}\n');
fprintf(out, '\\label{tab:vary_elitism}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

out = fopen('../report/task2_crossover.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
for x = PR_CROSS
    fprintf('pr_cross = %i\n', x)
    fprintf(out, '\\multicolumn{5}{c}{probability of crossover = %.2f}\\\\ \n\\midrule\n', x);
    test_run(datasetslist, out, SCALING, RUNS, NIND(2), MAXGEN(2), ELITIST(2), STOP_PERCENTAGE, x, PR_MUT(2), CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
    if x ~= PR_CROSS(end); fprintf(out, '\\midrule\n'); end
end		
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm with varying probability of crossover.}\n');
fprintf(out, '\\label{tab:vary_crossover}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

out = fopen('../report/task2_mutation.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
for x = PR_MUT
    fprintf('pr_mut = %i\n', x)
    fprintf(out, '\\multicolumn{5}{c}{probability of mutation = %.2f}\\\\ \n\\midrule\n', x);
    test_run(datasetslist, out, SCALING, RUNS, NIND(2), MAXGEN(2), ELITIST(2), STOP_PERCENTAGE, PR_CROSS(6), x, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
    if x ~= PR_MUT(end); fprintf(out, '\\midrule\n'); end
end		
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm with varying probability of mutation.}\n');
fprintf(out, '\\label{tab:vary_mutation}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);