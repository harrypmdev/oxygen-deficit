extends TileMapLayer

var tile_size = Vector2(64, 64) # Replace with your actual tile size
var player_position = Vector2.ZERO
var tile_offset = Vector2.ZERO

func _ready():
	player_position = get_viewport().get_camera().global_position

func _process(delta: float):
	var new_position = get_viewport().get_camera().global_position
	if player_position.distance_to(new_position) > tile_size.length():
		tile_offset += (new_position - player_position).sign()
		player_position = new_position
		update_tiles()

func update_tiles():
	var viewport_rect = get_viewport().get_visible_rect()
	var start_x = int(viewport_rect.position.x / tile_size.x) - 1
	var start_y = int(viewport_rect.position.y / tile_size.y) - 1
	var end_x = int((viewport_rect.position.x + viewport_rect.size.x) / tile_size.x) + 1
	var end_y = int((viewport_rect.position.y + viewport_rect.size.y) / tile_size.y) + 1

	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			var local_position = Vector2(x, y) * tile_size
			var world_position = local_position + player_position.floor() % tile_size
	
