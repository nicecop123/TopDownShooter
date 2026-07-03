extends Node2D

@export var player: Node2D
const CHUNK_SCENE=preload("res://src/scenes/chunk.tscn")

var chunk_pixel_size=512
var view_radius: int=2

var world_data: Dictionary={}
var active_chunks: Dictionary={}

var optimisation_timer: float=0.0

func _ready() -> void:
	if player == null:
		print("CRITICAL WARNING: Player is NOT assigned in the MapManager Inspector slot!")
		return
	
	print("MapManager initialized. Spawning starting world chunks...")
	managechunks()

func _process(delta: float) -> void:
	optimisation_timer+=delta
	if optimisation_timer>1.0:
		optimisation_timer=0
		managechunks()

func managechunks():
	if not player:
		return
		
	var player_chunk_x = round(player.global_position.x / chunk_pixel_size)
	var player_chunk_y = round(player.global_position.y / chunk_pixel_size)
	var current_chunk_coord = Vector2(player_chunk_x, player_chunk_y)

	var visible_coords: Array=[]
	
	for x in range(current_chunk_coord.x - view_radius, current_chunk_coord.x + view_radius + 1):
		for y in range(current_chunk_coord.y - view_radius, current_chunk_coord.y + view_radius + 1):
			visible_coords.append(Vector2(x, y))
	
	for coord in active_chunks.keys():
		if not coord in visible_coords:
			active_chunks[coord].queue_free()
			active_chunks.erase(coord)
	
	for coord in visible_coords:
		if not active_chunks.has(coord):
			load_or_create_chunk(coord)

func load_or_create_chunk(coord: Vector2):
	var new_chunk = CHUNK_SCENE.instantiate()
	new_chunk.global_position=coord*chunk_pixel_size
	
	get_parent().get_node("BaseTerrain").add_child(new_chunk)
	active_chunks[coord]=new_chunk
	await get_tree().process_frame
	
	if not active_chunks.has(coord):
		return
	
	if world_data.has(coord):
		var saved_props = world_data[coord]
		new_chunk.call("restore_props",saved_props)
	else:
		var generated_props=new_chunk.call("generate_random_props")
		world_data[coord]=generated_props
