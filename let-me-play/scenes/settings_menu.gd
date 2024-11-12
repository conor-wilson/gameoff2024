extends Node2D

signal back_pressed
signal shake_screen(strength:float, fade:float)

@export var devUsername := "QuietLantern"

@onready var username_box: LineEdit = $CenterContainer/MarginContainer/VBoxContainer/UsernameBox
@onready var password_box: LineEdit = $CenterContainer/MarginContainer/VBoxContainer/PasswordBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	username_box.hide()
	password_box.hide()

func _on_secret_settings_button_pressed() -> void:
	username_box.show()
	username_box.grab_focus()

func _on_username_box_text_submitted(new_text: String) -> void:
	print("Username Entered: ", new_text)
	username_box.clear()
	
	if new_text == devUsername:
		password_box.show()
		password_box.grab_focus()
		
		var lines: Array[String] = [
			"Nice job! \\(^o^)/",
			"Unfortunately, you'll also need his password...",
			"<TO BE CONTINUED>"
		]
		DialogueManager.stop_all_dialogue()
		DialogueManager.new_dialogue_sequence($DialogueMarkers/WrongPasswordMarker.global_position, lines)
	else:
		shake_screen.emit(15, 5)
		var lines: Array[String] = [
			"Damn ¬_¬ the dev locked it behind his username...",
			"I bet he credited himself somewhere around here... >.>"
		]
		DialogueManager.stop_all_dialogue()
		DialogueManager.new_dialogue_sequence($DialogueMarkers/WrongPasswordMarker.global_position, lines)

func _on_password_box_text_submitted(new_text: String) -> void:
	print("Password Entered: ", new_text)
	password_box.clear()

func _on_button_pressed() -> void:
	back_pressed.emit()
