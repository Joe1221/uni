function model = main()
clear;

global model g_orig gamma_old;
%import com.comsol.model.*
%import com.comsol.model.util.*



model = ForwardModel();



% Specify prescribed data for u
%                  v----------- x coordinate
%                     v-------- y coordinate
%                        v----- u value (dirichlet data)
specified_data = [ 0, 2, 1; ...
                  -3, 0, 1; ...
                   0,-2, 1; ...
                   2, 0, 1  ];

% To use the points of prescribed data as measurement points
measure_points = specified_data(:,1:2);

% To specify measurepoints equidistant on the unit circle:
%[X, Y] = pol2cart(linspace(-pi,pi,10), 2 * ones(1,10));
%measure_points = [X', Y'];

% To use the curve points as measurement points
%measure_points = load('C.mat', '-ascii');


% Löse das Vorwärtsproblem mit „echtem“ Gamma, um Testdaten zu erhalten
% =====================================================================

model.setOuterBoundary(load('C.mat', '-ascii'));
model.setInnerBoundary(load('Gamma.mat', '-ascii'));
model.buildGeometry();
model.buildMesh();

model.setDirichletInnerData('0');
model.setDirichletOuterData(specified_data);
model.runStudy();

figure(1);
model.makePlot();

% Testdaten für g
g_orig = model.getNeumannData(measure_points);


% Löse jetzt das eigentliche inverse Problem
% =====================================================================



%gamma_init = load('GammaInit.mat', '-ascii');
b = 0.5*load('C2.mat', '-ascii');  % So funktioniert es nicht 
a = 2*pi/size(b,2) * ones(size(b,1),1);   
gamma_init = pol2cart(a,b);
model.setInnerBoundary(gamma_init);
%model.setNeumannOuterData('1');
model.buildMesh();
model.runStudy();

figure(2);
model.makePlot();

tol = 10^-3;
gamma_old = gamma_init;

function g_diff = H (gamma)
	model.setInnerBoundary(gamma)
	model.runStudy();
	g_diff = model.getNeumannData(measure_points) - g_orig;

	if norm(gamma_old - gamma) > tol
		figure();
		model.makePlot();
        gamma
	end
	gamma_old = gamma;
end


options = optimoptions(@fsolve, 'Algorithm', 'levenberg-marquardt');

t1 = tic;
fsolve(@H, gamma_init, options)
toc(t1)

figure()
model.makePlot();


end
