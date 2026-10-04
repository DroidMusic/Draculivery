extends Moveable

func scene_setup() -> void:
	consumer = true

func _input(event: InputEvent) -> void:
	if !event.is_pressed():
		return
	var direction := Vector3i.ZERO
	match event.as_text():
		"Up":
			direction = Vector3i.FORWARD
		"Down":
			direction = Vector3i.BACK
		"Left":
			direction = Vector3i.LEFT
		"Right":
			direction = Vector3i.RIGHT
		"Z":
			Level.undo_last_move()
			return
		_:
			return
	if can_move(direction) and Level.total_power > 0:
		Level.total_power -= 1
		Level.past_turns.append([])
		move(direction)
		Level.successful_move.emit()
