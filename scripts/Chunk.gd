extends Node
const chunk_size = 46
var starting_coords
var ending_coords
var noise
var map = Array()
var tilemap
var thread
var previous_chunk_details
var current_cells

func _init(player_position: Vector2i, noise, tilemap, previous_chunk_details=null):
	self.noise = noise
	self.tilemap = tilemap
	var tilemap_position = tilemap.local_to_map(player_position)
	self.starting_coords = Vector2i(
		tilemap_position.x - (chunk_size/2),
		tilemap_position.y - (chunk_size/2)
	)
	self.ending_coords = Vector2i(
		starting_coords.x + chunk_size,
		starting_coords.y + chunk_size,
	)
	self.previous_chunk_details = previous_chunk_details
	self.current_cells = self.tilemap.get_used_cells()
	generate()

func generate():
	map.resize(chunk_size)
	for i in range(chunk_size):
		map[i] = []
	for y in range(chunk_size):
		map[y] = []
		for x in range(chunk_size):
			if previous_chunk_details and in_previous_chunk(x,y):
				map[y].append(-1)
			else:
				var noise_value = noise.get_noise_2d(
					starting_coords.x + x,
					starting_coords.y + y
				)
				if noise_value > 0.125 or noise_value < -0.1 :
					map[y].append(1)
				else:
					map[y].append(0)

func apply_to_tilemap():
	var cell_updates = get_map()
	tilemap.set_cells_terrain_connect(cell_updates, 0, 0,)

func in_previous_chunk(x, y):
	return Vector2i(x, y) in current_cells
	#var prior_start = previous_chunk_details.starting_coords
	#var prior_end = previous_chunk_details.ending_coords
	#var coords = Vector2i(starting_coords.x + x, starting_coords.y + y)
	#var in_chunk = (prior_start.x <= coords.x and coords.x < prior_end.x) and (prior_start.y <= coords.y and coords.y < prior_end.y)

func get_map():
	var cell_updates = []
	for y in range(chunk_size):
		for x in range(chunk_size):
			if map[y][x] == -1:
				continue
			elif map[y][x]:
				cell_updates.append(Vector2i(
						starting_coords.x + x, 
						starting_coords.y + y 
				))
	return cell_updates

func get_chunk_details():
	var map_details = {}
	for y in range(chunk_size):
		for x in range(chunk_size):
			var coords = Vector2i(starting_coords.x + x, starting_coords.y + y)
			if map[y][x]:
				map_details[coords] = 1
	return {
		"starting_coords": starting_coords,
		"ending_coords": ending_coords,
		"map": map_details
	}

func kill():
	queue_free()
