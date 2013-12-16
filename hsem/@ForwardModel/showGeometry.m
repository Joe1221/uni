function showGeometry (obj)
	obj.buildGeometry();
	%subplot(1, 3, 1);
	mphgeom(obj.model, obj.geom.tag());
end
