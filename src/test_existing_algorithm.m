% Number of individuals
NIND=[50 100 250 500 1000];	
% Maximum no. of generations
MAXGEN=[100 250 500 1000];
% percentage of the elite population
ELITIST=[0 0.05 0.15 0.35 0.50 0.75 0.95];    
% Generation gap
GGAP=1-ELITIST;		
% percentage of equal fitness individuals for stopping
STOP_PERCENTAGE=.95;    
% probability of crossover
PR_CROSS=[0 0.15 0.35 0.50 0.75 .95];     
% probability of mutation
PR_MUT=[0 .05 0.15 0.35 0.50 0.75 0.95];       
% local loop removal
LOCALLOOP=[0 1];      
% default crossover operator
CROSSOVER = 'cross_alternating_edges';  
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
datasetslist = datasetslist([1 2 3 7 10 13]);
%datasetslist = datasetslist([1 2 3]);

out = fopen('../report/task2_individuals.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
for x = NIND
    fprintf('nind = %i\n', x)
    fprintf(out, '\\multicolumn{5}{c}{number of individuals = %i}\\\\ \n\\midrule\n', x);
    test_run(datasetslist, out, SCALING, RUNS, x, MAXGEN(1), ELITIST(2), STOP_PERCENTAGE, PR_CROSS(6), PR_MUT(2), CROSSOVER, LOCALLOOP(1), CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
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
    test_run(datasetslist, out, SCALING, RUNS, NIND(1), x, ELITIST(2), STOP_PERCENTAGE, PR_CROSS(6), PR_MUT(2), CROSSOVER, LOCALLOOP(1), CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
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
    test_run(datasetslist, out, SCALING, RUNS, NIND(1), MAXGEN(1), x, STOP_PERCENTAGE, PR_CROSS(6), PR_MUT(2), CROSSOVER, LOCALLOOP(1), CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
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
    test_run(datasetslist, out, SCALING, RUNS, NIND(1), MAXGEN(1), ELITIST(2), STOP_PERCENTAGE, x, PR_MUT(2), CROSSOVER, LOCALLOOP(1), CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
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
    test_run(datasetslist, out, SCALING, RUNS, NIND(1), MAXGEN(1), ELITIST(2), STOP_PERCENTAGE, PR_CROSS(6), x, CROSSOVER, LOCALLOOP(1), CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
    if x ~= PR_MUT(end); fprintf(out, '\\midrule\n'); end
end		
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm with varying probability of mutation.}\n');
fprintf(out, '\\label{tab:vary_mutation}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);

out = fopen('../report/task2_loop.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
for x = LOCALLOOP
    fprintf('local_loop_removal = %i\n', x)
    fprintf(out, '\\multicolumn{5}{c}{local loop removal = %i}\\\\ \n\\midrule\n', x);
    test_run(datasetslist, out, SCALING, RUNS, NIND(1), MAXGEN(1), ELITIST(2), STOP_PERCENTAGE, PR_CROSS(6), PR_MUT(2), CROSSOVER, x, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)
    if x ~= LOCALLOOP(end); fprintf(out, '\\midrule\n'); end
end		
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm with varying local loop removal.}\n');
fprintf(out, '\\label{tab:vary_loop}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);