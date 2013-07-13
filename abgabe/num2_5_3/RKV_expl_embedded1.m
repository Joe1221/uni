% Numerik 2 Blatt 5
% Verena Treitz, 2665281
% Aufgabe 5.3, Aufgabenteil a)
% Versuch 1

function [xi,hat_yi] = RKV_expl_embedded1(A,b1,b2,c,f,y0,x0,T,h0,tol,tau,p)
n = (T - x0)/h0 + 1;    % Da mindestens so viele Schritte auf jeden Fall 
                        % gemacht werden
% Vor-initialisierung der Vektoren, da so viele Einträge auf jeden Fall
% gemacht werden, sowie eintragen von y0 und x0
xi = zeros(n,1);
y = zeros(n,2);
yh = zeros(n,2); % eigentlich hat_yi, so ist es aber übersichtlicher
y(1,:) = y0;
yh(1,:) = y0;
xi(1) = x0;

% eta für y, etah für yh, ebenso die Summen
s = length(c);
eta = zeros(s,2); % Diese Vektoren werden für jedes i wieder überschrieben.
etah = zeros(s,2);
etaSumme = [0;0]; 
etahSumme = [0;0];

h = zeros(n,1);
h(1) = h0;

i = 1;
while xi(i) < T
    % Berechnen der etas
    eta(1,:) = y(i,:); % muss eta bei y_i oder bei hat_yi beginnen??
    etah(1,:)= yh(i,:);
    for k = 2:s
        a = A(k, :);
        % Spart Rechenaufwand, da die Summe unabhängig von h ist
        if etaSumme(1) == 0 && etaSumme(2) == 0 && etahSumme(1) == 0 && etahSumme(2) == 0
            for l = 1:k-1 % Da die Matrix A ein explizites RKV vorgibt
                etaSumme = etaSumme + a(l) * f(eta(l,1),eta(l,2));
                etahSumme = etahSumme + a(l) * f(etah(l,1),etah(l,2));
            end
        end
        eta(k,:) = y(i,:) + h(i) * etaSumme';
        etah(k,:) = yh(i,:) + h(i) * etahSumme';
    end
    %Berechnen der Summe zur Berechnung von y_i+1 bzw. yh_i+1
    ySumme = [0;0];
    yhSumme = [0;0];
    for j = 1:s
       ySumme = ySumme + b1(j) * f(eta(j,1),eta(j,2));
       yhSumme = yhSumme + b2(j) * f(etah(j,1),etah(j,2));
    end
    % Berechnen von y_i+1 und yh_i+1
    y(i+1,:) = yh(i,:) + h(i) * ySumme';
    yh(i+1,:) = yh(i,:) + h(i) * yhSumme';
    
    % Berechnen von delta_i+1
    delta = ((y(i+1,1)-yh(i+1,1))^2 + (y(i+1,2) - yh(i+1,2))^2)^(1/2);
    
    % Fallunterscheidung: bei delta_i+1 >= tol wird wiederholt
    if delta >= tol
        h(i) = tau * h(i) * (tol/delta)^(1/(p+1));
    % Bei delta_i+1 < tol wird h_i+1 = h mit h = angepasste Schrittweite
    % gesetzt (zumindest habe ich die Aufgabenstellung so verstanden)
    elseif delta < tol && delta > eps
        i = i + 1;
        %h(i) = h0;
        h(i) = tau * h(i-1) * (tol/delta)^(1/(p+1));
        xi(i) = xi(i-1) + h(i-1);
        etaSumme = [0;0];
        etahSumme = [0;0];
    % Sonstige Fälle, insbesondere delta = 0 bzw. delta < eps
    else
       i = i + 1;
       % h(i) = h0;
        %h(i) = h(i-1);
        h(i) =  h(i-1)*tau*5^(1/(p+1));
        xi(i) = xi(i-1) + h(i-1);
        etaSumme = [0;0];
        etahSumme = [0;0];
        eta = zeros(s,2);
        etah = zeros(s,2);
    end
end
hat_yi = yh;

%figure
%hold on
%plot(y(:,1),y(:,2),'r');
%plot(yh(:,1),yh(:,2),'b');

end