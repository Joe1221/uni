# Morphologische Filter


Thema zum Seminar „Numerik der Bildverarbeitung“ an der Universität Stuttgart im Sommersemester 2015, vorgetragen von Stephan Hilb.




## Seminarvortrag

Der Folien-Quellcode findet sich im `tex`-Verzeichnis.
Bilder dafür werden mit dem Skript `matlab/genimages.m` generiert.




## Matlab Programmierprojekt

Alles spielt sich im `matlab`-Verzeichnis ab.

### Erosion/Dilatation

Eine manuelle Implementierung findet sich in `my_imerode.m`, bzw. `my_imdilate.m`.
Ein Vergleich (visuell und bezüglich Performance) zwischen dieser und der Matlab-Implementierung findet sich in `erodecompare.m`.

### Interaktive GUI

Morphologische Filter hautnah erleben, siehe `morphgui.m`.

### Scan Aufarbeitung

Siehe `rscan.m`, Aufruf in Matlab:

    im = imreadgray('images/scanned/scan-300dpi-light.png');
    rscan(im);

Erzeugte Bilder im `out`-Verzeichnis.




## Lizenz

Tex-Quellcode unter Creative Commons (explizit: CC BY-NC-SA 3.0).
Matlab-Quellcode unter der GPLv3 (mit Ausnahme von `matlab/timeit.m`, siehe URL in der Datei).
Bilder unter der Public Domain.
Beachte Vermerke innerhalb der Dateien.
