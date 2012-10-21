% Parameter
t = transpose(linspace(0,2*pi));
p = [];
for lambda = -5:0.1:5
    p = [p; complex(1/(2*lambda) + cos(t)/(2*lambda), sin(t)/(2*lambda))];
end

plot(p);
