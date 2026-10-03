extends Node3D
class_name Moveable

var tile := Vector3i.ZERO
var tween: Tween
var pushable = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile = position / 2
	position = tile * 2.0
	scene_setup()

func scene_setup() -> void:
	return

func _enter_tree() -> void:
	Level.moveables.append(self)

func _exit_tree() -> void:
	Level.moveables.erase(self)

func can_move(direction: Vector3i) -> bool:
	if Level.is_tile_wall(tile + direction):
		return false

	var moveable := Level.get_moveables_at_tile(tile + direction)
	if moveable and moveable.pushable:
		return moveable.can_move(direction)

	return true

func move(direction: Vector3i) -> void:
	var moveable := Level.get_moveables_at_tile(tile + direction)
	if moveable and moveable.pushable:
		moveable.move(direction)
	slide(direction)
	
	Level.add_move_to_turn(self, direction)

func slide(direction: Vector3i) -> void:
	position = tile * 2.0
	tile += direction
	
	var target := tile * 2.0
	tween = create_tween()
	tween.tween_property(self, "position", target, 0.05)
