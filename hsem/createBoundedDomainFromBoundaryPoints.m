function geom = createBoundedDomainFromBoundaryPoints (geom, domainName, boundaryName, pointData)

% Äußere Randkurve
boundary = geom.feature.create(boundaryName, 'InterpolationCurve');
boundary.set('table', pointData);
boundary.set('type', 'closed');
% Erstelle Gebiet aus Randkurve
domain = geom.feature.create(domainName, 'ConvertToSolid');
domain.selection('input').set({boundaryName});
domain.set('createselection', 'on');

end
