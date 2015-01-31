
for geomcell = {'semicircleg', 'sectorg'}
	geom = geomcell{:};

	figure(1)
	%[p,e,t] = initmesh('semicircleg', 'Hmax', 0.5);
	[p,e,t] = initmesh(geom, 'Hmax', 0.5);
	mypdeplot(p,e,t);
	matlab2tikz([geom, '_init.tex'], 'height', '\fheight', 'width', '\fwidth');
	figure(2)

	for i = 1:2
		%[p,e,t] = refinemesh(geom,p,e,t,[1:size(t,2)],'longest');
		[p,e,t] = bisect(geom,p,e,t,1:size(t,2));
		mypdeplot(p,e,t);
		pause(0.20);
	end
	mypdeplot(p,e,t);
	matlab2tikz([geom, '_global.tex'], 'height', '\fheight', 'width', '\fwidth');

	figure(3)
	[p,e,t] = initmesh(geom, 'Hmax', 0.5);
	for i = 1:7
		[~, pr] = min(sum((p - repmat([-0.4; 0.2], [1, size(p,2)])) .^ 2, 1)); % nearest point at origin
		k = find(t(1,:) == pr | t(2,:) == pr | t(3,:) == pr);
		k
		[p,e,t] = bisect(geom,p,e,t,k);
		mypdeplot(p,e,t);
		pause(0.20);
	end
	mypdeplot(p,e,t);
	matlab2tikz([geom, '_local.tex'], 'height', '\fheight', 'width', '\fwidth');


end

