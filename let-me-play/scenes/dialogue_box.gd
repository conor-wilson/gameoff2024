class_name DialogueBox extends MarginContainer

# TODO: Review this code and tidy it all up

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer

var follow_node:CanvasItem = null

var line_queue: Array[String] = [] # The list of lines that are queued to be displayed.

const MAX_WIDTH = 256

var text = ""
var letter_index = 0


const BLUE_BOX:Texture2D = preload("res://assets/art/DialogueBox.png")
const RED_BOX:Texture2D  = preload("res://assets/art/DialogueBox_Red.png")

var letter_time = 0.03
var space_time = 0.06
var punc_time = 0.2
signal finished_displaying

# TODO: This is just so janky... create a proper constructor when there is time
func set_colour(colour:String):
	match colour:
		"red":
			$NinePatchRect.texture = RED_BOX
			$MarginContainer/Label.add_theme_color_override("font_color", Color("ac3232"))
		"blue":
			$NinePatchRect.texture = BLUE_BOX
			$MarginContainer/Label.add_theme_color_override("font_color", Color("3f3f74"))
		_: 
			$NinePatchRect.texture = BLUE_BOX
			$MarginContainer/Label.add_theme_color_override("font_color", Color("3f3f74"))

func _process(delta: float) -> void:
	_follow_node_if_exists()

func _follow_node_if_exists():
	if follow_node != null:
		position = follow_node.position + Vector2(48, 16)

func display_text(new_text:String):
	
	_follow_node_if_exists()
	
	text = new_text
	label.text = new_text
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # Wait for x resize
		await resized # Wait for y resize
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24 
	
	label.text = ""
	_display_letter()

func _display_letter():
	
	_follow_node_if_exists()
	label.text += text[letter_index]
	
	letter_index += 1 
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	match text[letter_index]: 
		"!", ".", ",", "?":
			timer.start(punc_time)
		" ": 
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_timer_timeout() -> void:
	_follow_node_if_exists()
	_display_letter()
