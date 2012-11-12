% Stephan Hilb, 2706616

D = double(imread('Bild.png'));
N = length(D);

figure(1), imshow(uint8(real(D)));

% Fast Fourier Transformation
C = ff2d(D);
%C = fft2(D); % Matlabfunktion zum Testen

% Frequenzen rausfiltern
C(40:210,:) = 0;
C(:,40:210) = 0;

% Inverse Fast Fourier Transformation
D = N*N * conj(ff2d(conj(C)));
%D = ifft2(C); % Matlabfunktion zum Testen

figure(2), imshow(uint8(real(D)));

