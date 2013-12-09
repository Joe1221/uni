function model = main()
clear;

%import com.comsol.model.*
%import com.comsol.model.util.*


model = ForwardModel();

M = [0,2,1; -3,0,2; 0,-2,3; 2,0,4];
model.setFValue(M);

model.setOuterBoundary(load('C2.mat', '-ascii'));
model.setInnerBoundary(load('Gamma.mat', '-ascii'));

figure(1);
model.showGeometry();

figure(2);
model.run();



end
