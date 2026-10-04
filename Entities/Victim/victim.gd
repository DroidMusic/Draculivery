extends Moveable

var direction := Vector3i.ZERO

func scene_setup() -> void:
	Level.successful_move.connect(wander)
	direction = Vector3i.LEFT

func wander() -> void:	
	if can_move(direction):
		move(direction)
	else:
		direction = direction * -1
		if can_move(direction):
			move(direction)
	
	var moveable := Level.get_moveables_at_tile(tile)
	if moveable and moveable.consumer:
		move(Vector3i.DOWN * 2)
		Level.total_victims += 1
