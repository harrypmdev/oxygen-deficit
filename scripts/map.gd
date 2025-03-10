extends Node2D

@export var noise_height_text : NoiseTexture2D
@export var rock_chance : float
@export var generate : bool
@export var width : int = 150
@export var height : int = 150
var noise
var source_id = 1
var map = Array()

func _ready():
	if generate:
		noise = noise_height_text.noise
		noise.seed = randi()
		generate_world()
		#for i in range(4):
			#smooth_map()
		apply_to_tilemap()
	
func generate_world():
	map.resize(width)
	var lowest = 1
	var heighest = -1
	for y in range(height):
		map[y] = []
		for x in range(width):
			var noise_value = noise.get_noise_2d(x, y)
			if noise_value > heighest:
				heighest = noise_value
			if noise_value < lowest:
				lowest = noise_value
			if noise_value > 0.125 or noise_value < -0.1 :
				map[y].append(1)
			else:
				map[y].append(0)
	print("Lowest:" + str(lowest))
	print("Heighest:" + str(heighest))

func smooth_map():
	var new_map = map.duplicate()
	for y in range(height):
		for x in range(width):
			var neighbor_count = count_neighbors(x, y)
			if neighbor_count > 4:
				new_map[y][x] = 1
			elif neighbor_count < 4:
				new_map[y][x] = 0
	map = new_map

func count_neighbors(x, y):
	var count = 0
	for ny in range(y - 1, y + 2):
		for nx in range(x - 1, x + 2):
			if ny == y and nx == x:
				continue
			if nx >= 0 and nx < width and ny >= 0 and ny < height:
				if map[ny][nx] == 1:
					count += 1
	return count

func apply_to_tilemap():
	var tilemap = $RockTiles
	for y in range(height):
		for x in range(width):
			if map[y][x]:
				tilemap.set_cells_terrain_connect(
					[Vector2(x, y)], 0, 0,
				)

#func generate_world():
	#for x in range(-width/2, width / 2):
		#for y in range(-height/2, height/2):
			#var noise_val = noise.get_noise_2d(x, y)
			#print(noise_val)
			#if noise_val > -0.59:
				#$RockTiles.set_cells_terrain_connect(
					#[Vector2(x, y)], 0, 0,
				#)
				#pass
				
