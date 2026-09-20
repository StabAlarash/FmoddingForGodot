@tool
extends EditorScenePostImport

const GLTF_PATH = "res://assets/models/gltf"
const SCENES_PATH = "res://assets/models/scenes"

func _post_import(scene):
	iterate(scene, scene)
	return scene

func iterate(node, root):
	if node != null:
		print_rich("Post-import: [b]%s[/b]" % [node.name])
		#node.name = "mod_" + node.name
		
		# LINK
		if node.name.begins_with(">>"):
			print("link found: %s" % node)
			var base_name:String = node.name.right(-2)
			var scene_name := base_name
			var parts := scene_name.split("_")
			if parts[-1].is_valid_int():
				scene_name = scene_name.left(-parts[-1].length()-1)
			print(scene_name)
			var resource_path = "%s/%s.tscn" % [SCENES_PATH, scene_name]
			if not ResourceLoader.exists(resource_path):
				resource_path = "%s/%s.glb" % [GLTF_PATH, scene_name]
			
			var parent = node.get_parent()
			var house:Node3D = load(resource_path).instantiate()
			parent.add_child(house)
			house.position = node.position
			house.rotation = node.rotation
			house.scale = node.scale
			
			house.owner = root
			#fix_internal_owners(house, root)
			
			parent.move_child(house, node.get_index())
			
			node.queue_free()
			house.name = base_name
			return
			
		if false and node.name.ends_with("-area"):
			print("Area %s" % [node.name])
			var parent = node.get_parent()
			var area := Area3D.new()
			parent.add_child(area)
			parent.move_child(area, node.get_index())
			area.position = node.position
			area.rotation = node.rotation
			area.scale = node.scale
			area.owner = root
			
			var collision_shape = CollisionShape3D.new()
			area.add_child(collision_shape)
			
			node.queue_free()
			area.name = node.name
			
			fix_internal_owners(area, root)
		
		for child in node.get_children():
			iterate(child, root)

func fix_internal_owners(node: Node, root: Node) -> void:
	for child in node.get_children():
		child.owner = root
		fix_internal_owners(child, root)
