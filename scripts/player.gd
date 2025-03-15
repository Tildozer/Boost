extends RigidBody3D

# basis helps determin what is up based on the scences(player) rotation
var local_up: Vector3 = basis.y

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_central_force(basis.y * delta * 1000.0)
	if Input.is_action_pressed("ui_left"):
		apply_torque(Vector3(0.0, 0.0, 100.0 * delta))
	if Input.is_action_pressed("ui_right"):
		apply_torque(Vector3(0.0, 0.0, -100.0 * delta))
