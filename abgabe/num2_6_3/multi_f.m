% Ruft eine Funktion jeweils blockweise auf zwei Vektorargumente auf.
% Das erste Argument zu Blöcken der Größe 1 und das zweite zu Blöcken der
% Größe blocksize.
% multi_f Gibt die Ausgaben der Funktion angeordnet als Vektor der Größe
% blocknum zurück. Dabei spielt es keine Rolle, welche Form die Ausgabe von
% f hat.
function [ fout ] = multi_f ( f, fargs1, fargs2, blocksize, blocknum )

    % Wende f jeweils auf die einzelnen Komponenten an (etwas umständlich,
    % geht mit Sicherheit einfacher)
    fout = cell2mat(cellfun(f, ...
                            num2cell(fargs1, 2), ...
                            num2cell(reshape(fargs2, blocksize, blocknum), 1)', ...
                            'UniformOutput', false) ...
                   );

end

