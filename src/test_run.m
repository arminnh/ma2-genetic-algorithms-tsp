function test_run(datasetslist, out, SCALING, RUNS, NIND, MAXGEN, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP)

Ndatasets = size(datasetslist, 1) - 2;
results = zeros([Ndatasets 4]);

for ds = 1:Ndatasets
    fprintf('%s\n', datasetslist(ds + 2).name)
    
    data = load(['datasets/' datasetslist(ds + 2).name]);

    x = data(:,1);
    y = data(:,2);

    if SCALING == 1
        x = x / max([data(:,1); data(:,2)]);
        y = y / max([data(:,1); data(:,2)]);
    end

    NVAR=size(data,1); % No. of variables (cities)

    for i = 1:RUNS
        [best, mean, worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, CUSTOMSTOP, CUSTOMSS, SELECTION, SUBPOP);
        Ngen = find(best, 1, 'last');
        B = best(Ngen);
        M = mean(Ngen);
        W = worst(Ngen);

        results(ds, :) = results(ds, :) + [Ngen B M W];
    end

    results(ds, :) = results(ds, :) / RUNS;

    fprintf(out, '%s & %.1f & %.2f & %.2f & %.2f \\\\\n', datasetslist(ds + 2).name, results(ds, 1), results(ds, 2), results(ds, 3), results(ds, 4));
end

end

