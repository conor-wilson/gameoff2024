extends Node2D

signal hammer_man_escaped(global_pos:Vector2)
signal level_changed
signal block_break
signal hammer_man_death
signal s_collected

@onready var levels:Array[Node2D] = [
	$Levels/TitleScreen,
	$Levels/Level1,
	$Levels/Level2,
	$Levels/Level3,
	$Levels/VictoryScreen
]

@onready var current_level:Node2D = $Levels/TitleScreen

func _ready() -> void:
	start_level($Levels/TitleScreen)

func _process(delta: float) -> void:
	if !$Levels/Level3/S.can_collect:
		$Levels/Level3/S.can_collect = check_s_collectable()

func open():
	$HammerMan.active = true
	$HammerMan.show()
	start_level($Levels/TitleScreen)

func close():
	$HammerMan.active = false
	start_level(null)

func start_level(desired_level:Node2D):
	
	current_level = desired_level
	
	for level in levels:
		
		# Hide the rest of the levels
		if level != current_level:
			level.hide()
		
		# Disable all other levels' layers
		for child in level.get_children():
			if child is TileMapLayer:
				child.enabled = level == current_level
			elif child is BlobEnemy:
				if level == current_level:
					child.respawn()
				else:
					child.kill()
	
	# Show the desired level and move HammerMan to start position
	if desired_level != null:
		desired_level.show()
	$HammerMan.position = $HammerManSpawnPoint.position
	level_changed.emit()

func check_s_collectable() -> bool:
	var blocking_coords:Array[Vector2i] = [
		Vector2i(1,3), Vector2i(2,3), Vector2i(3,3),
		Vector2i(1,4), Vector2i(2,4), Vector2i(3,4),
		Vector2i(1,5), Vector2i(2,5), Vector2i(3,5),
	]
	for blocking_coord in blocking_coords:
		if $Levels/Level3/BreakableBlocks.get_cell_atlas_coords(blocking_coord) != Vector2i(-1,-1):
			return false
	
	return true

func _on_escape_zone_body_entered(body: Node2D) -> void:
	if body is HammerMan:
		body.hide()
		body.active = false
		hammer_man_escaped.emit(body.global_position)
		$HammerMan.position = $HammerManSpawnPoint.position


func _on_level_0_door_body_entered(body: Node2D) -> void:
	if body is HammerMan && current_level == $Levels/TitleScreen:
		start_level($Levels/Level1)

func _on_level_1_door_body_entered(body: Node2D) -> void:
	if body is HammerMan && current_level == $Levels/Level1:
		start_level($Levels/Level2)

func _on_level_2_door_body_entered(body: Node2D) -> void:
	if body is HammerMan && current_level == $Levels/Level2:
		start_level($Levels/Level3)

func _on_level_3_door_body_entered(body: Node2D) -> void:
	if body is HammerMan && current_level == $Levels/Level3:
		start_level($Levels/VictoryScreen)

func _on_level_1_blob_enemy_hit() -> void:
	start_level($Levels/Level1)
	hammer_man_death.emit()

func _on_level_2_blob_enemy_hit() -> void:
	start_level($Levels/Level2)
	hammer_man_death.emit()

func _on_level_3_blob_enemy_hit() -> void:
	start_level($Levels/Level3)
	hammer_man_death.emit()

func _on_hammer_man_block_break() -> void:
	block_break.emit()

func _on_blinker_timer_timeout() -> void:
	if $Levels/TitleScreen/Controls.visible:
		$Levels/TitleScreen/Controls.hide()
	else:
		$Levels/TitleScreen/Controls.show()


func _on_s_collect() -> void:
	s_collected.emit()
