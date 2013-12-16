function makePlot(obj)

	% Make sure plot is initialized
	if ~isa(obj.pg1, 'com.comsol.model.impl.ResultFeatureImpl')
		obj.initPlot();
	end

	fprintf('Plotting Result ... ');
	obj.pg1.run;
	mphplot(obj.model, 'pg1');
	fprintf('finished.\n');

end
