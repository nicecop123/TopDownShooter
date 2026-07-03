extends TileMapLayer

const PROP_SOURCE_ID = 1
const TREE_SCENE = preload("res://src/scenes/tree.tscn")

# POOL OF DECORATIONS: Add the Atlas Coordinates of all your different props here!
var decoration_pool: Array[Vector2i] = [
	Vector2i(1, 6), # Tree variant 1
	Vector2i(0, 7), # Tree variant 2
	Vector2i(1, 7), 
	Vector2i(0, 10) 
]

@onready var decoration_layer = $DecorationLayer
@onready var prop_locations_node = $PropLocations
@onready var tree_locations_node = $TreeSpawnLocations

var spawned_tree_nodes: Array[Node2D] = []

func generate_random_props() -> Dictionary:
	var markers = prop_locations_node.get_children()
	var saved_choices: Dictionary = {}
	
	markers.shuffle()
	
	# Pick 4 random markers
	for i in range(4):
		var marker = markers[i]
		var marker_index = marker.get_index()
		
		var random_prop_index = randi() % decoration_pool.size()
		var chosen_atlas_coord = decoration_pool[random_prop_index]
		
		saved_choices[marker_index] = random_prop_index
		
		var tile_pos = local_to_map(marker.position)
		decoration_layer.set_cell(tile_pos, PROP_SOURCE_ID, chosen_atlas_coord)
		
	spawn_physical_trees()
	
	return saved_choices

func restore_props(saved_choices: Dictionary) -> void:
	var markers = prop_locations_node.get_children()
	
	for marker_index in saved_choices.keys():
		var marker = markers[int(marker_index)]
		var random_prop_index = saved_choices[marker_index]
		var chosen_atlas_coord = decoration_pool[random_prop_index]
		
		var tile_pos = local_to_map(marker.position)
		decoration_layer.set_cell(tile_pos, PROP_SOURCE_ID, chosen_atlas_coord)
	
	spawn_physical_trees()


func spawn_physical_trees() -> void:
	clear_physical_trees()
	var tree_markers = tree_locations_node.get_children()
	
	if tree_markers.size() == 0:
		return
	
	tree_markers.shuffle()
	
	var entities_node = get_parent().get_parent().get_node("Entities")
	
	for i in range(min(2, tree_markers.size())):
		var marker = tree_markers[i]
		var tree_instance = TREE_SCENE.instantiate()
		
		tree_instance.global_position = to_global(marker.position)
		
		entities_node.add_child(tree_instance)
		spawned_tree_nodes.append(tree_instance)

func clear_physical_trees() -> void:
	for tree in spawned_tree_nodes:
		if is_instance_valid(tree):
			tree.queue_free()
	spawned_tree_nodes.clear()
	
func _exit_tree() -> void:
	clear_physical_trees()
