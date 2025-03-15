extends RigidBody3D

# basis helps determin what is up based on the scences(player) rotation
var local_up: Vector3 = basis.y

## How much verticle force is applied when moving
@export_range(100.0, 5000.0) var thrust: float = 1000.0

## How much torque applied to player when rotating
@export_range(50.0, 500.0) var torque_thrust: float = 100.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(local_up * delta * thrust)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
	

func _on_body_entered(body: Node) -> void:
	#print(body.name)
	if "goal" in body.get_groups():
		print("you win")
	if "obstacle" in body.get_groups():
		print("you lose")
