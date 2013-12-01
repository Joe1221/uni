function initModel(obj)
	fprintf('Creating Model ... ');

	%obj.model = ComsolModel();
	obj.model = com.comsol.model.util.ModelUtil.create('Model');
	obj.model.hist.disable; % saves memory

	fprintf('finished.\n');
end
