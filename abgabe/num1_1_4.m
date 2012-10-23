% Stephan Hilb, 2706616

% Aufgabenteil a)
for n = 4:2:12
    subplot(5,2,n-3);
    
    Xs = -1 + (0:n).*(2/n);
    Ys = 1./(1 + 12*Xs.^2);
    p = polyfit(Xs,Ys,n);
    
    % Ausgabe des Polynoms
    str = '';
    for i = n:-1:1
        str = strcat(str, num2str(p(n-i+1),'%+f'), '*x^', num2str(i));
    end
    str = strcat(str, '+', num2str(p(n+1)))
    
    Xp = linspace(min(Xs),max(Xs),200);
    Yp = polyval(p,Xp);
    
    plot(Xp,Yp,'b-',Xs,Ys,'bo','markersize',4,'markerfacecolor','b');
    
    % Funktion f(x)
    hold on
    Xp = linspace(-1,1,200);
    Yp = 1./(1+12*Xp.^2);
    plot(Xp,Yp,'--r');
    hold off ;
    axis([-1,1,-0.5,1]);
end

% Aufgabenteil b)
for n = 4:2:12
    subplot(5,2,n-2);
    
    Xs = cos((n-(0:n))*pi/n);
    Ys = 1./(1 + 12*Xs.^2);
    p = polyfit(Xs,Ys,n);
    
    % Ausgabe des Polynoms
    str = '';
    for i = n:-1:1
        str = strcat(str, num2str(p(n-i+1),'%+f'), '*x^', num2str(i));
    end
    str = strcat(str, '+', num2str(p(n+1)))
    
    Xp = linspace(min(Xs),max(Xs),200);
    Yp = polyval(p,Xp);
    
    plot(Xp,Yp,'b-',Xs,Ys,'bo','markersize',4,'markerfacecolor','b'); 
    
    % Funktion f(x)
    hold on
    Xp = linspace(-1,1,200);
    Yp = 1./(1+12*Xp.^2);
    plot(Xp,Yp,'--r');   
    hold off;
    axis([-1,1,-0.5,1]);
end