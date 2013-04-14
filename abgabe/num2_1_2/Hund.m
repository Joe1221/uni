function Hund(a, c, T, h)
	P(1,:) = [0,0];
	H1(1,:) = [-1,0];
	H2(1,:) = [-1,0];
	i = 1;

	for t = 0:h:T
		% Person
		P(i+1,:) = P(i,:) + [0, 1] * a*h;

		% Hund1
		d = (P(i,:) - H1(i,:))/norm(P(i,:) - H1(i,:));
		H1(i+1,:) = H1(i,:) + d * c*h;
		% Hund2
		d = (P(i+1,:) - H2(i,:))/norm(P(i+1,:) - H2(i,:));
		H2(i+1,:) = H2(i,:) + d * c*h;

		i++;
	end

	plot(P(:,1), P(:,2), H1(:,1), H1(:,2), H2(:,1), H2(:,2));
	axis([-1, 0.5, 0, 2]);
	axis equal;
	legend('Person', 'Hund1 (H,P)', 'Hund2 (P,H)');
end
