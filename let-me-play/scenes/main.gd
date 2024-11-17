extends Node

var screen_shake_strength:float = 0.0
var screen_shake_fade:float     = 5.0

func _ready() -> void:
	$Cameras/MainMenuCamera.make_current()
	CursorManager.set_mouse_cursor(CursorManager.CURSOR)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apply_screen_shake(delta)

func apply_screen_shake(delta: float):
	
	# No shake required if the strength is below the shake threshold
	if screen_shake_strength <= 0.001:
		screen_shake_strength = 0
		return
	
	# Shake the screen
	var offset:Vector2 = Vector2(
		randf_range(-screen_shake_strength, screen_shake_strength), 
		randf_range(-screen_shake_strength, screen_shake_strength),
	)
	$Cameras/MainMenuCamera.offset = offset
	$Cameras/SettingsCamera.offset = offset
	
	# Fade the screen shake for the next time
	screen_shake_strength = lerpf(screen_shake_strength, 0, screen_shake_fade*delta)

func _on_main_menu_shake_screen(strength:float, fade:float) -> void:
	shake_screen(strength, fade)

func _on_settings_menu_shake_screen(strength: float, fade: float) -> void:
	shake_screen(strength, fade)

func shake_screen(strength:float, fade:float):
	screen_shake_strength = strength
	if fade != 0:
		screen_shake_fade = fade

func _on_main_menu_settings_pressed() -> void:
	$Cameras/SettingsCamera.make_current()

func _on_settings_menu_back_pressed() -> void:
	$Cameras/MainMenuCamera.make_current()


func _on_main_menu_start_button_exploded() -> void:
	
	# Shake the screen
	shake_screen(30.0, 5.0)
	
	# Start the "What was that?" dialogue
	await get_tree().create_timer(4).timeout
	var lines: Array[String] = [
		"...What was that?",
		"Was that what I think it was? o_o",
		"Honestly... I told that dev to fix that START GAME button before release...",
		"Oh well, luckily I can fix it for you ^_^",
		"You'll have come and unlock me first though..."
	]
	DialogueManager.new_dialogue_sequence($DialogueMarkers/WhatWasThat1.position, lines)
	DialogueManager.new_dialogue_sequence($DialogueMarkers/WhatWasThat2.position, lines)
#
# TODO: This is purely for debugging. This function should be removed once it's
# no-longer needed.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debugbutton"): 
		DialogueManager.stop_all_dialogue()
		CursorManager.set_mouse_cursor(CursorManager.WRENCH)