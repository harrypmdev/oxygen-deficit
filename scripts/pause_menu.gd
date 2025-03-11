extends Control
var popup_scene = preload("res://scenes/pause_popup.tscn")

func _ready():
	visible = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			visible = not visible
			get_tree().paused = not get_tree().paused

func _on_menu_pressed() -> void:
	var popup_instance = popup_scene.instantiate()
	var text = "Are you sure you wish to return to the menu? Your run will be over."
	var yes = func(_popup):		
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	var no = func(popup):
		popup.queue_free()
	popup_instance.set_text(text, yes, no)
	add_child(popup_instance)

func _on_restart_pressed() -> void:
	var popup_instance = popup_scene.instantiate()
	var text = "Are you sure you wish to restart? Your current run will be over."
	var yes = func(_popup):		
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
	var no = func(popup):
		popup.queue_free()
	popup_instance.set_text(text, yes, no)
	add_child(popup_instance)
