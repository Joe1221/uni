function model = main()
clear;

%import com.comsol.model.*
%import com.comsol.model.util.*


model = ForwardModel();


M = [0,2,0; -3,0,1; 0,-2,2; 2,0,3];
model.setDirichletOuterData(M);

model.setOuterBoundary(load('C2.mat', '-ascii'));
model.setInnerBoundary(load('Gamma.mat', '-ascii'));

figure(1);

%model.setDirichletOuterData('1');
model.buildGeometry();
model.buildMesh();
model.runStudy();
model.makePlot();

figure(2);
%model.setNeumannOuterData('1');
M = [0,2,0; -3,0,1; 0,-2,-2; 2,0,3];
model.setNeumannOuterData(M);
model.buildMesh();
model.runStudy();
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
