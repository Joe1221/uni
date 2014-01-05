function model = main()
clear;

%import com.comsol.model.*
%import com.comsol.model.util.*


model = ForwardModel();


M = [0,2,1; -3,0,2; 0,-2,3; 2,0,4];
model.setDirichletOuterData(M);

model.setOuterBoundary(load('C2.mat', '-ascii'));
model.setInnerBoundary(load('Gamma.mat', '-ascii'));

%model.showGeometry();
%model.buildGeometry();

%figure(2);
%model.run();

figure(2);
%model.initMesh();
%model.buildMesh();
%model.initStudy();
%model.runStudy();

%model.initPlot();


model.setOuterBoundary(load('C2.mat', '-ascii'));
model.buildGeometry();
model.buildMesh();
model.runStudy();
model.makePlot();

figure(3);
model.setOuterBoundary(load('C.mat', '-ascii'));
model.buildGeometry();
model.buildMesh();
model.runStudy();
model.makePlot();

figure(4);
model.setOuterBoundary(load('C2.mat', '-ascii'));
model.buildGeometry();
model.buildMesh();
model.runStudy();
model.makePlot();



end
