function model = main()
clear;

global model g_orig;
%import com.comsol.model.*
%import com.comsol.model.util.*








model = ForwardModel();


M = [0,2,1; -3,0,1; 0,-2,1; 2,0,1];
pointdata = M(:,1:2);

[X, Y] = pol2cart(2 * linspace(-pi,pi,10), ones(1,10))
pointdata = [X', Y'];



% === Löse das Vorwärtsproblem mit „echtem“ Gamma, um Testdaten zu erhalten ===

model.setDirichletOuterData(M);

model.setOuterBoundary(load('C2.mat', '-ascii'));
model.setInnerBoundary(load('Gamma.mat', '-ascii'));

figure(1);

%model.setDirichletOuterData('1');
model.buildGeometry();
model.buildMesh();
model.runStudy();
model.makePlot();

% Testdaten für g
g_orig = model.getNeumannData(pointdata);


% === Löse jetzt das eigentliche inverse Problem ===

figure(2);
gamma_init = load('GammaInit.mat', '-ascii');
model.setInnerBoundary(gamma_init);
%model.setNeumannOuterData('1');
model.buildMesh();
model.runStudy();
model.makePlot();


function g_diff = H (gamma)
	model.setInnerBoundary(gamma)
	model.runStudy();
	g_diff = model.getNeumannData(pointdata) - g_orig;
end

figure(3)
fsolve(@H, gamma_init)
model.makePlot();

%figure(3);
%model.setOuterBoundary(load('C.mat', '-ascii'));
%model.buildGeometry();
%model.buildMesh();
%model.runStudy();
%model.makePlot();
%
%figure(4);
%model.setOuterBoundary(load('C2.mat', '-ascii'));
%model.buildGeometry();
%model.buildMesh();
%model.runStudy();
%model.makePlot();
%


end
