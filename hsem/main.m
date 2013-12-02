function main()
clear;

%import com.comsol.model.*
%import com.comsol.model.util.*


model = ForwardModel();

model.setOuterBoundary(load('C2.mat', '-ascii'));
model.setInnerBoundary(load('Gamma.mat', '-ascii'));

figure(1);
model.showGeometry();

figure(2);
model.run();



end
