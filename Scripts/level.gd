extends Node

signal successful_move

class Move:
	var node: Moveable
	var direction: Vector3i
	var num_victims: int

var gridmap: GridMap
var moveables: Array[Moveable]

var total_power: int = 50
var total_victims: int = 0

var past_turns: Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().scene_changed.connect(level_changed)
	level_changed()

func level_changed() -> void:
	gridmap = get_tree().get_first_node_in_group("LevelGridMap")

func is_tile_wall(tile: Vector3i) -> bool:
	return gridmap != null and gridmap.get_cell_item(tile) == 0

func is_floor_ice(tile: Vector3i) -> bool:
	return gridmap != null and gridmap.get_cell_item(tile - Vector3i(0,1,0)) == 2


func get_moveables_at_tile(tile: Vector3i) -> Moveable:
	for node: Moveable in moveables:
		if node.tile == tile:
			return node
	return null

func add_move_to_turn(node: Moveable, direction: Vector3i, num_victims: int = total_victims) -> void:
	var move := Move.new()
	move.node = node
	move.direction = direction
	move.num_victims = num_victims
	past_turns.back().append(move)
	
func undo_last_move() -> void:
	if !past_turns.is_empty():
		Level.total_power += 1
		var last_moves: Array = past_turns.pop_back()
		for move: Move in last_moves:
			Level.total_victims = move.num_victims
			move.node.slide(-move.direction)
