extends ColorRect
var yes_callback
var no_callback

func set_text(text, yes_callback: Callable, no_callback: Callable):
	$Label.text = "[center]" + text + "[/center]"
	self.yes_callback = yes_callback
	self.no_callback = no_callback

func _on_yes_pressed() -> void:
	yes_callback.call(self)

func _on_no_pressed() -> void:
	no_callback.call(self)
