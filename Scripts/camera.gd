extends Camera3D

@export var target: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		global_position.x = lerp(global_position.x, target.global_position.x, 0.1)
