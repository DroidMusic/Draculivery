extends Moveable

var direction := Vector3i.ZERO

func scene_setup() -> void:
	Level.successful_move.connect(wander)
	direction = Vector3i.LEFT

func wander() -> void:	
	print(tile)
	if can_move(direction):
		move(direction)
	else:
		direction = direction * -1
		if can_move(direction):
			move(direction)
