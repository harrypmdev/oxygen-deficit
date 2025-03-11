extends ColorRect
var yes_callback
var no_callback

func set_text(text, yes: Callable, no: Callable):
	$Label.text = "[center]" + text + "[/center]"
	self.yes_callback = yes
	self.no_callback = no

func _on_yes_pressed() -> void:
	yes_callback.call(self)

func _on_no_pressed() -> void:
	no_callback.call(self)
