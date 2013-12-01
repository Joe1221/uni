function showGeometry (obj)
	obj.geom.run;
	%subplot(1, 3, 1);
	mphgeom(obj.model, obj.geom.tag());
end
