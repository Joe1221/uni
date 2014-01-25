function model = main()
clear;

global g_orig gamma_old obj_func;



model = ForwardModel();



% Specify prescribed data for u (also known as f)
% -----------------------------------------------
%                  v----------- x coordinate
%                     v-------- y coordinate
%                        v----- u value (dirichlet data)
%specified_data = [ 0, 2, 1; ...
%                  -3, 0, 1; ...
%                   0,-2, 1; ...
%                   2, 0, 1  ];
%specified_data = '1';
m = 30;
% fixme: from 0 to 2pi !, no double begin/end point !
phi_step = 2*pi / m;
[X, Y] = pol2cart(linspace(0, 2*pi - phi_step, m), 2 * ones(1,m));
measurement_points = [X', Y'];
specified_data = [measurement_points, ones(size(measurement_points, 1), 1)];

% Specify measurement points for u (for g-values to be measured)
% --------------------------------------------------------------

% To use the points of prescribed data as measurement points
%measurement_points = specified_data(:,1:2)

% To specify measurepoints equidistant on the unit circle:
[X, Y] = pol2cart(linspace(0, 2*pi - phi_step, m), 2 * ones(1, m));
measurement_points = [X', Y'];
measured_data = [measurement_points, zeros(size(measurement_points, 1), 1)];

% To use the curve points as measurement points
%measure_points = load('C.mat', '-ascii');

% Löse das Vorwärtsproblem mit „echtem“ Gamma, um Testdaten zu erhalten
% =====================================================================

fprintf('Generating test data (forward problem) ...\n');

c_curve = load('C.mat', '-ascii');
gamma_curve = load('Gamma.mat', '-ascii');
gamma0_curve = load('GammaInit.mat', '-ascii');


model.setOuterBoundary(c_curve);
model.setInnerBoundary(gamma_curve);
model.buildGeometry();
model.buildMesh();

% Dry-run, to be able to make evaluations
model.runStudy();
specified_data(:, 1:2) = model.snapToBoundary(specified_data(:, 1:2));
measured_data(:, 1:2) = model.snapToBoundary(measured_data(:, 1:2));

model.setDirichletInnerData('0');
model.setDirichletOuterData(specified_data);
model.runStudy();


figure(1);
model.makePlot();

% Testdaten für g
measured_data = model.getNeumannData(measured_data(:, 1:2));


% Löse jetzt das eigentliche inverse Problem
% =====================================================================

fprintf('Solving the inverse problem ...\n');

figure(2);

inv_model = InverseModel(c_curve, specified_data, measured_data, gamma0_curve);
model = inv_model;

%return;

inv_model.solveLevenbergMarquardtFD();



end
