function makePlot(obj)
fprintf('Evaluating Result ... ');

pg1 = obj.model.result.create('pg1', 2);
pg1.feature.create('surf1', 'Surface');

pg1.run;
mphplot(obj.model, 'pg1');

fprintf('finished\n');

end