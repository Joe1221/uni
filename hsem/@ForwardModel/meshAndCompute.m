function meshAndCompute(obj, rf)
if nargin == 1
    rf = '5';
else
    rf = int2str(rf);
end

% ============ MESH ============
fprintf('Generating Mesh ... ');

mesh = obj.model.mesh.create('mesh', obj.geom_name);
mesh.feature.create('ftri1', 'FreeTri');
mesh.feature('size').set('hauto', rf); % Gitterauflösung: 1-9 (fine - coarse)

mesh.run;
mphmesh(obj.model, 'mesh');

fprintf('finished\n');
% ============ STUDY ============
fprintf('Running Study ... ');
	
study = obj.model.study.create('std1');
study.feature.create('st1', 'Stationary');

study.run;

fprintf('finished\n');

end
