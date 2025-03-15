extends RigidBody3D

## How much verticle force is applied when moving
@export_range(100.0, 5000.0) var thrust: float = 1000.0

## How much torque applied to player when rotating
@export_range(50.0, 500.0) var torque_thrust: float = 100.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
	

func _on_body_entered(body: Node) -> void:
	if "goal" in body.get_groups():
		call_deferred("complete_level", body.file_path)
	if "obstacle" in body.get_groups():
		crash_sequence()

func crash_sequence() -> void:
	print("kaboom")
	get_tree().call_deferred("reload_current_scene")

func complete_level(next_level_file: String) -> void:
	print("you win")
	get_tree().change_scene_to_file(next_level_file)
