function meshAndCompute(obj, rf)

	% ============ MESH ============
	obj.initMesh(rf);
	obj.buildMesh();

	% ============ STUDY ============
	obj.initStudy();
	obj.runStudy();

end
