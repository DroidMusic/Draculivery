extends Node3D
class_name Moveable

var tile := Vector3i.ZERO
var tween: Tween
var pushable = false
var consumer = false

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
		return moveable.can_move(direction / direction.length())

	return true

func move(direction: Vector3i) -> void:
	if Level.is_floor_ice(tile + direction):
		for i in range(1,150):
			var extended_dir = (direction * i)
			var nexttile = tile + extended_dir
			
			var moveable_on_ice := Level.get_moveables_at_tile(nexttile)
			if moveable_on_ice and moveable_on_ice.pushable and moveable_on_ice.can_move(direction):
				moveable_on_ice.move(direction)
			
			if !(Level.is_floor_ice(nexttile) and can_move(extended_dir)):
				if(!can_move(extended_dir)):
					i = i - 1
				direction = (direction * i)
				break
			i =+ 1
			
	var moveable := Level.get_moveables_at_tile(tile + direction)
	if moveable and moveable.pushable:
		moveable.move(direction / direction.length())
			
	slide(direction)
	Level.add_move_to_turn(self, direction, Level.total_victims)

func slide(direction: Vector3i) -> void:
	position = tile * 2.0
	tile += direction
	
	var target := tile * 2.0
	tween = create_tween()
	tween.tween_property(self, "position", target, 0.1)
