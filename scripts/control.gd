extends Control
var player
var death_played = false

func _ready() -> void:
	for child in get_parent().get_parent().get_children():
		if child is DemoPlayer:
			player = child

func _process(delta: float) -> void:
	var print_position = Vector2i(
		floor(player.global_position.x),
		floor(player.global_position.y)
	)
	var depth = get_parent().get_parent().player_tilemap_position.y
	if depth < 0:
		$Depth.text = str(abs(depth)) + "m Above Start"
	else:
		$Depth.text = str(abs(depth)) + "m Deep"
	if player.dead and not death_played:
		$AnimationPlayer.play("darken")
		$death_depth.text = $Depth.text
		death_played = true
	if player.item != player.items.NONE:
		$ItemSheet.visible = true
		$ItemSheet.frame = player.item + 1
	$O2.size.x = player.o2
	$Hearts.size.x = player.health * 12.5

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")

func enable_buttons():
	$RestartButton.disabled = false
	$RestartButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$MenuButton.disabled = false
	$MenuButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	
