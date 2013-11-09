function out = model(job)

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');
%ModelUtil.showProgress(true);
figure(1);


% ============ GEOMETRIE ============

% Geometrie erstellen
geom = model.geom.create('geom', 2);
model.coordSystem().create('polar', 'geom', 'Cylindrical'); % Ermöglich die Verwendung von Polarkoordinaten mittels polar.r, polar.phi

% Äußere Randkurve C
C = geom.feature.create('C', 'InterpolationCurve');
C.set('table', load('C.mat', '-ascii'));
C.set('type', 'closed');
% Erstelle Gebiet Omega aus C
g_Omega = geom.feature.create('Omega', 'ConvertToSolid');
g_Omega.selection('input').set({'C'});
g_Omega.set('createselection', 'on');

% Innere Randkurve Gamma
g_Gamma = geom.feature.create('Gamma', 'InterpolationCurve');
g_Gamma.set('table', load('Gamma.mat', '-ascii'));
g_Gamma.set('type', 'closed');
% Erstelle Gebiet D aus Gamma
g_D = geom.feature.create('D', 'ConvertToSolid');
g_D.selection('input').set({'Gamma'});
g_D.set('createselection', 'on');

% Ziehe D von Omega ab, damit das Innere von D am Ende nicht als selection auftritt
g_domain = geom.feature.create('domain', 'Difference');
g_domain.selection('input').set({'Omega'});
g_domain.selection('input2').set({'D'});
g_domain.set('createselection', 'on');

geom.run;
subplot(1, 3, 1);
mphgeom(model, 'geom');

% ============ PHYSIK ============

% Physik erzeugen und Parameter der DGL festlegen
ph = model.physics.create('ph', 'CoefficientFormPDE', 'geom');
ph.selection.named('geom_domain_dom'); % DGL nur auf der domain (Omega ohne D)
ph_eq = ph.feature('cfeq1');
ph_eq.set('c', -1);
ph_eq.set('a', 0);
ph_eq.set('f', 0);   % Rechte Seite, gleich 0
ph_eq.set('ea', 0);
ph_eq.set('da', 0);
ph_eq.set('al', [0 0]); % al, be, ga sind vektoren
ph_eq.set('be', [0 0]);
ph_eq.set('ga', [0 0]);

% Randbedingung für C (u = f)
ph_bnd_C = ph.feature.create('C', 'DirichletBoundary', 1);
ph_bnd_C.selection.named('geom_Omega_bnd');
%ph_bnd_C.set('r', 'x^2-2*y+2');
ph_bnd_C.set('r', 'cos(3*polar.phi) + 2*sin(polar.phi)');

% Randbedingung für Gamma (u = 0)
ph_bnd_Gamma = ph.feature.create('Gamma', 'DirichletBoundary', 1);
ph_bnd_Gamma.selection.named('geom_D_bnd');
ph_bnd_Gamma.set('r', '0');


% ============ MESH ============

mesh = model.mesh.create('mesh', 'geom');
mesh.feature.create('ftri1', 'FreeTri');
mesh.feature('size').set('hauto', '5'); % Gitterauflösung: 1-9 (fine - coarse)

mesh.run;
subplot(1, 3, 2);
mphmesh(model, 'mesh');

% ============ STUDY ============

study = model.study.create('std1');
study.feature.create('st1', 'Stationary');

study.run;

% ============ PLOT ============

pg1 = model.result.create('pg1', 2);
pg1.feature.create('surf1', 'Surface');

pg1.run;
subplot(1, 3, 3);
mphplot(model, 'pg1');





%myfunc = model.func.create('myfunc', 'Analytic');

%pg = model.result.create('pg1', 2);


%sel = model.selection.create('sel2', 'Explicit');
%sel.geom(1);
%sel.set([5 6 7 8]);


%model.modelPath('/afs/stud.mathematik.uni-stuttgart.de/home/2011/hilbsn/uni/hsem');

%model.name('Objekt2.mph');




out = model;
