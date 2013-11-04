function out = model
%
% test1.m
%
% Model exported on Oct 21 2013, 17:08 by COMSOL 4.3.2.189.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/afs/stud.mathematik.uni-stuttgart.de/home/2011/hilbsn/uni/hsem');

model.modelNode.create('mod1');

model.geom.create('geom1', 2);

model.mesh.create('mesh1', 'geom1');

model.physics.create('c', 'CoefficientFormPDE', 'geom1', {'u'});

model.study.create('std1');
model.study('std1').feature.create('stat', 'Stationary');
model.study('std1').feature('stat').activate('c', true);

model.geom('geom1').feature.create('sq1', 'Square');
model.geom('geom1').feature('sq1').set('type', 'solid');
model.geom('geom1').feature('sq1').set('base', 'corner');
model.geom('geom1').feature('sq1').set('pos', {'0' '0'});
model.geom('geom1').feature('sq1').set('size', '1');
model.geom('geom1').run('sq1');
% model.geom('geom1').move({'sq1'}, [-0.5 -0.4]);
model.geom('geom1').feature('sq1').set('pos', {'-0.5' '-0.4'});
model.geom('geom1').run('sq1');
% model.geom('geom1').move({'sq1'}, [0.05 0]);
model.geom('geom1').feature('sq1').set('pos', {'-0.45' '-0.4'});
model.geom('geom1').run('sq1');
% model.geom('geom1').move({}, [0 -0.1]);
model.geom('geom1').run('sq1');
% model.geom('geom1').move({'sq1'}, [0 -0.1]);
model.geom('geom1').feature('sq1').set('pos', {'-0.45' '-0.5'});
model.geom('geom1').run('sq1');
% model.geom('geom1').scale({}, [1.5499999523162842 1.5], [0.55 0.5]);
model.geom('geom1').run('sq1');
% model.geom('geom1').scale({'sq1'}, [1.5499999523162842 1.5], [0.55 0.5]);
model.geom('geom1').feature.create('sca1', 'Scale');
model.geom('geom1').feature('sca1').selection('input').init;
model.geom('geom1').feature('sca1').selection('input').set({'sq1'});
model.geom('geom1').feature('sca1').set('pos', [0.55 0.5]);
model.geom('geom1').feature('sca1').set('type', 'anisotropic');
model.geom('geom1').feature('sca1').set('anisotropic', [1.5499999523162842 1.5]);
model.geom('geom1').run('sca1');
% model.geom('geom1').scale({'sca1'}, [1.2903226613998413 1.3333333730697632], [-0.9999999 -1]);
model.geom('geom1').feature('sca1').setIndex('anisotropic', '2.0000000636424', 0);
model.geom('geom1').feature('sca1').setIndex('anisotropic', '2.0000000596046', 1);
model.geom('geom1').feature('sca1').set('pos', {'0.099999932501585' '-2.9802320611338E-8'});
model.geom('geom1').run('sca1');
model.geom('geom1').feature.create('c1', 'Circle');
model.geom('geom1').feature('c1').set('type', 'solid');
model.geom('geom1').feature('c1').set('base', 'center');
model.geom('geom1').feature('c1').set('pos', {'0' '0'});
model.geom('geom1').feature('c1').set('r', '0.4');
model.geom('geom1').run('c1');
model.geom('geom1').run;

model.physics('c').feature('cfeq1').set('da', 1, '0');
model.physics('c').feature('cfeq1').set('f', 1, '0');
model.physics('c').feature('cfeq1').set('c', 1, {'-1' '0' '0' '-1'});

model.geom('geom1').feature.create('dif1', 'Difference');
model.geom('geom1').run;

model.physics('c').selection.set([1 2]);
model.physics('c').selection.named('sel1');
model.physics('c').selection.all;
model.physics('c').selection.set([1]);
model.physics('c').selection.all;
model.physics('c').selection.set([]);
model.physics('c').selection.all;
model.physics('c').selection.set([1]);

model.geom('geom1').feature.create('dif1', 'Difference');
model.geom('geom1').run;

model.mesh('mesh1').run;

model.geom('geom1').run('sq1');
model.geom('geom1').run('c1');
model.geom('geom1').runPre('sca1');
model.geom('geom1').feature('sq1').set('base', 'center');
model.geom('geom1').feature('sq1').setIndex('pos', '0', 0);
model.geom('geom1').feature('sq1').setIndex('pos', '0', 1);
model.geom('geom1').run('sq1');
model.geom('geom1').feature('sq1').set('size', '2');
model.geom('geom1').run('sq1');
model.geom('geom1').feature.remove('sca1');
model.geom('geom1').runAll;
model.geom('geom1').run;

model.selection.create('sel2');
model.selection('sel2').geom(2);
model.selection('sel2').name('Omega ohne D');
model.selection('sel2').set([1]);

model.physics('c').selection.named('sel2');
model.physics('c').feature.create('dir1', 'DirichletBoundary', 1);
model.physics('c').feature('dir1').selection.set([5 6 7 8]);

model.selection.create('sel3');
model.selection('sel3').geom(1);
model.selection('sel3').name('Rand von D');
model.selection('sel3').set([5 6 7 8]);

model.physics('c').feature('dir1').selection.named('sel3');
model.physics('c').feature('dir1').set('r', 1, '=0');
model.physics('c').feature('dir1').set('r', 1, '0');
model.physics('c').feature.create('cons1', 'Constraint', 1);
model.physics('c').feature('cons1').set('R', 1, 'u');
model.physics('c').feature.remove('cons1');
model.physics('c').feature.create('dir2', 'DirichletBoundary', 1);
model.physics('c').feature.remove('dir2');
model.physics('c').feature.create('cons1', 'Constraint', 1);
model.physics('c').feature('cons1').set('R', 1, 'u(x)-f');

model.func.create('pw1', 'Piecewise');
model.func('pw1').model('mod1');
model.func('pw1').set('fununit', 'x^2');
model.func('pw1').set('argunit', '');
model.func('pw1').set('fununit', '');
model.func('pw1').set('extrap', 'constant');
model.func.remove('pw1');
model.func.create('an1', 'Analytic');
model.func('an1').model('mod1');
model.func('an1').set('expr', 'sin(x)');

model.variable.create('var1');
model.variable('var1').model('mod1');
model.variable.remove('var1');

model.probe.create('bnd1', 'Boundary');
model.probe('bnd1').model('mod1');
model.probe('bnd1').selection.named('sel3');
model.probe('bnd1').selection.all;
model.probe('bnd1').selection.set([1 2 3 4]);

model.selection.create('sel4');
model.selection('sel4').geom(1);
model.selection('sel4').name('Rand von Omega');
model.selection('sel4').set([1 2 3 4]);

model.probe('bnd1').selection.named('sel4');

model.func('an1').set('funcname', 'f');

model.probe('bnd1').set('descr', 'Dependent variable u x-coordinate');

model.physics('c').feature.remove('cons1');
model.physics('c').feature.create('dir2', 'DirichletBoundary', 1);
model.physics('c').feature('dir2').selection.named('sel4');
model.physics('c').feature('dir2').set('r', 1, 'x');

model.mesh('mesh1').run;

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.create('pg1', 2);
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', 'u');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.physics('c').feature('dir2').set('r', 1, 'sin(x)*sin(y)');

model.mesh('mesh1').run;

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.func('an1').set('args', 'x,y');
model.func('an1').set('expr', 'sin(x)*cos(y)');
model.func('an1').setIndex('plotargs', '-1', 0, 1);
model.func('an1').setIndex('plotargs', '1', 1, 1);
model.func('an1').setIndex('plotargs', '-1', 1, 1);

model.physics('c').feature('dir2').set('r', 1, 'f(x,y)');

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.func('an1').set('expr', 'sin(2*pi*x)*cos(2*pi*y)');

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.func('an1').set('expr', 'sin(pi*x)*cos(pi*y)');

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.geom('geom1').runAll;

model.mesh('mesh1').run;

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.func('an1').set('expr', 'cos(pi*x)*cos(pi*y)');

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

% model.geom('geom1').move({'c1'}, [0.3 -0.3]);
model.geom('geom1').feature('c1').set('pos', {'0.3' '-0.3'});
model.geom('geom1').run('c1');
model.geom('geom1').run;

model.mesh('mesh1').run;

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.func('an1').set('expr', 'exp(-x^2)*exp(y^2)');

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.probe('bnd1').genResult('none');

model.sol('sol1').runAll;

model.result('pg1').run;

model.selection.remove('sel1');

model.probe.remove('bnd1');

model.result('pg1').run;

out = model;
