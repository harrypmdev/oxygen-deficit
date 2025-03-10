extends Node
@export var noise_texture: NoiseTexture2D
@export var obj_noise_texture: NoiseTexture2D
var noise
var obj_noise
var chunk_width = 48
var chunk_height = 38
var distance_to_chunk = 120
var player_tilemap_position
var last_position
var changeset: Dictionary

var fish = preload('res://scenes/small_fish.tscn')
var o2_plant = preload('res://scenes/o_2_plant.tscn')
var decoration = preload('res://scenes/plant.tscn')
var big_fish = preload('res://scenes/fish.tscn')
var heart_plant = preload('res://scenes/heart_plant.tscn')
var loaded_plant = []
var loaded_fish = []
var loaded_decor = []
var loaded_big_fish = []
var loaded_heart_plant = []
var last_update
var death_loaded = false
var plant_rarity = 0.979
var fish_rarity = 0.95
var decor_rarity = 0.80
var big_fish_rarity = 0.798
var heart_plant_rarity = 0.796

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise = noise_texture.noise
	noise.seed = randi()
	obj_noise = obj_noise_texture.noise
	obj_noise.seed = randi() 
	generate_chunk($DemoPlayer.global_position)
	last_position = $DemoPlayer.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $DemoPlayer.dead and not death_loaded:
		death_loaded = true
		$AnimationPlayer.play('slow_music')
	player_tilemap_position = $Map/RockTiles.local_to_map($DemoPlayer.global_position)
	# Ensure changeset exists and is valid before checking readiness
	if changeset and changeset.has("valid") and BetterTerrain.is_terrain_changeset_ready(changeset):
		BetterTerrain.apply_terrain_changeset(changeset)
		changeset.clear()  # Clear the changeset instead of setting it to null
		spawn_objs(last_update)
	# Check if player has moved far enough to trigger chunk generation
	if $DemoPlayer.global_position.distance_to(last_position) > distance_to_chunk:
		last_position = $DemoPlayer.global_position
		generate_chunk($DemoPlayer.global_position)

func generate_chunk(player_pos: Vector2):
	var chunk_center = $Map/RockTiles.local_to_map(player_pos)
	var row_start = chunk_center.y - (chunk_height / 2)
	var row_end = chunk_center.y + (chunk_height / 2)
	var column_start = chunk_center.x - (chunk_width / 2)
	var column_end = chunk_center.x + (chunk_width / 2)
	set_grid_chunk(column_start, column_end, row_start, row_end)

func update_terrain():
	var real_width = chunk_width * 16
	var real_height = chunk_height * 16
	var top_left = Vector2(
		$DemoPlayer.global_position.x - real_width / 2,
		$DemoPlayer.global_position.y - real_height / 2
	)
	BetterTerrain.update_terrain_area($Map/RockTiles,
	Rect2(top_left, Vector2(real_width, real_height)))	

func set_grid_chunk(column_start, column_end, row_start, row_end):
	var update = {}
	for x in range(column_start, column_end):
		for y in range(row_start, row_end):
			var noise_value = noise.get_noise_2d(x, y)
			var val = 0 if (noise_value > 0.125 or noise_value < -0.125) else 1
			update[Vector2i(x, y)] = val
	last_update = update		
	changeset = BetterTerrain.create_terrain_changeset($Map/RockTiles, update)

func spawn_objs(update):
	for coord in update:
		generate_o2_plants(update, coord)
		generate_small_fish(update, coord)
		generate_decoration(update, coord)
		generate_big_fish(update, coord)
		generate_heart_plants(update, coord)

func generate_big_fish(update, coord):
	if (update[coord] == 1 and 
		coord not in loaded_big_fish
		and obj_noise.get_noise_2d(coord.x, coord.y) < decor_rarity
		and obj_noise.get_noise_2d(coord.x, coord.y) > big_fish_rarity
		and coord.y > 200):
		var clear = true
		var surrounding = [
			# Straight
			Vector2i(coord.x-1, coord.y), 
			Vector2i(coord.x+1, coord.y),
			Vector2i(coord.x, coord.y-1),
			Vector2i(coord.x, coord.y+1),
			# Diagonals
			Vector2i(coord.x+1, coord.y+1),
			Vector2i(coord.x+1, coord.y-1),
			Vector2i(coord.x-1, coord.y-1),
			Vector2i(coord.x-1, coord.y+1),
		]
		for vector in surrounding:
			if $Map/RockTiles.get_cell_source_id(vector) != -1:
				clear = false
		if clear:
			add_big_fish(coord)


func generate_small_fish(update, coord):
	if (update[coord] == 1 and 
		coord not in loaded_fish
		and obj_noise.get_noise_2d(coord.x, coord.y) > fish_rarity
		and obj_noise.get_noise_2d(coord.x, coord.y) < plant_rarity
		and coord.y not in [-2, -1, 0, 1, 2]):
		add_small_fish(coord)

func generate_o2_plants(update, coord):
	if (update[coord] == 1 and 
		obj_noise.get_noise_2d(coord.x, coord.y) > plant_rarity and 
		coord not in loaded_plant):
		var clear = false
		var surrounding = [Vector2i(coord.x-1, coord.y), Vector2i(coord.x+1, coord.y)]
		var rot = 0
		if $Map/RockTiles.get_cell_source_id(surrounding[0]) != -1:
			clear = true
		if $Map/RockTiles.get_cell_source_id(surrounding[1]) != -1:
			clear = true
			rot = 180
		if clear:
			add_plant(coord, rot)

func generate_heart_plants(update, coord):
	if (update[coord] == 1 and 
		obj_noise.get_noise_2d(coord.x, coord.y) < big_fish_rarity and 
		obj_noise.get_noise_2d(coord.x, coord.y) > heart_plant_rarity and 
		coord not in loaded_heart_plant):
		var clear = false
		var surrounding = [Vector2i(coord.x-1, coord.y), Vector2i(coord.x+1, coord.y)]
		var rot = 0
		if $Map/RockTiles.get_cell_source_id(surrounding[0]) != -1:
			clear = true
		if $Map/RockTiles.get_cell_source_id(surrounding[1]) != -1:
			clear = true
			rot = 180
		if clear:
			add_heart_plant(coord, rot)

func generate_decoration(update, coord):
	if (update[coord] == 1
		and obj_noise.get_noise_2d(coord.x, coord.y) < fish_rarity
		and obj_noise.get_noise_2d(coord.x, coord.y) > decor_rarity
		and coord not in loaded_decor):
		var clear = false
		var surrounding = Vector2i(coord.x, coord.y+1)
		if $Map/RockTiles.get_cell_source_id(surrounding) != -1:
			clear = true
		if clear:
			add_decoration(coord)

func add_small_fish(coord):
	var fish_instance = fish.instantiate()
	fish_instance.position = $Map/RockTiles.map_to_local(coord)
	fish_instance.position.y -= 8
	add_child(fish_instance)
	loaded_fish.append(coord)

func add_big_fish(coord):
	var fish_instance = big_fish.instantiate()
	fish_instance.position = $Map/RockTiles.map_to_local(coord)
	fish_instance.position.y -= 8
	add_child(fish_instance)
	loaded_big_fish.append(coord)

func add_plant(coord, rot):
	var o2_instance = o2_plant.instantiate()
	o2_instance.position = $Map/RockTiles.map_to_local(coord)
	o2_instance.position.y -= 8
	o2_instance.rotation_degrees = rot
	add_child(o2_instance)
	loaded_plant.append(coord)

func add_heart_plant(coord, rot):
	var heart_plant_instance = heart_plant.instantiate()
	heart_plant_instance.position = $Map/RockTiles.map_to_local(coord)
	heart_plant_instance.position.y -= 8
	heart_plant_instance.rotation_degrees = rot
	if rot:
		heart_plant_instance.get_node('PlantSprite').flip_v = true
	add_child(heart_plant_instance)
	loaded_heart_plant.append(coord)

func add_decoration(coord):
	var decoration_instance = decoration.instantiate()
	decoration_instance.position = $Map/RockTiles.map_to_local(coord)
	decoration_instance.position.y -= 8
	add_child(decoration_instance)
	loaded_decor.append(coord)
