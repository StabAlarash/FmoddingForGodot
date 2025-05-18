@tool
extends EditorScenePostImport

func _post_import(scene):
	iterate(scene)
	return scene
	
func iterate(node:Node3D):
	if node == null:
		return
	
	print_rich("Post-import: [b]%s[/b] -> [b]%s[/b]" % [node.name, "modified_" + node.name])
	#node.name = "modified_" + node.name
	var regex = RegEx.new()
	regex.compile("\\[(\\w+)\\]")
	var tags = regex.search(node.name)
	if tags:
		print(tags.strings[1])
		node.name = node.name.replace(tags.strings[0], "")
		
		for child in node.get_children():
			if child is StaticBody3D:
				child.name = "Collider-{tag}".format({"tag": tags.strings[1]})
	
	for child in node.get_children():
		iterate(child)
