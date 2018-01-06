NIND=450;
MAXGEN=400;
ELITIST=.45;
STOP_PERCENTAGE=.95;
PR_CROSS=.5;
PR_MUT=.4;
LOCALLOOP=1;
CROSSOVER = 'cross_alternating_edges';
MUTATION = 'mut_inversion';
SELECTION = 'sus';
SUBPOP = 1;
CUSTOMSTOP = 0;
CUSTOMSS = 0;
RUNS = 10;
SCALING = 1;

datasetslist = dir('datasets/');

out = fopen('../report/task2_tuning.tex', 'w');
fprintf(out, '\\begin{table}[H] \n\\centering \n\\makebox[\\textwidth]{\n');
fprintf(out, '\\begin{tabular}{l rrrr} \n\\toprule\n');
fprintf(out, 'Dataset & \\# Generations & Min & Mean & Max\\\\ \n\\midrule\n');
test_run(datasetslist, out, SCALING, RUNS, NIND, MAXGEN, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
fprintf(out, '\\bottomrule \n\\end{tabular} \n}\n');
fprintf(out, '\\caption{Existing genetic algorithm after parameter tuning.}\n');
fprintf(out, '\\label{tab:existing_tuning}\n');	
fprintf(out, '\\end{table}\n');
fclose(out);