extends Node2D

signal shake_screen(strength:float, fade:float)

func _on_start_button_collision() -> void:
	shake_screen.emit(30.0, 5.0)
	for letter in $Letters.get_children(): 
		letter.spawn()
