extends RigidBody3D

## How much verticle force is applied when moving
@export_range(100.0, 5000.0) var thrust: float = 1000.0

## How much torque applied to player when rotating
@export_range(50.0, 500.0) var torque_thrust: float = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $explosionAudio
@onready var success_audio: AudioStreamPlayer = $successAudio
@onready var rocket_thrust: AudioStreamPlayer3D = $rocketAudio

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		if !rocket_thrust.playing:
			rocket_thrust.play()
	else:
		rocket_thrust.stop()
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
	

func _on_body_entered(body: Node) -> void:
	if !is_transitioning:
		if "goal" in body.get_groups():
			call_deferred("complete_level", body.file_path)
		if "obstacle" in body.get_groups():
			call_deferred("crash_sequence")

func crash_sequence() -> void:
	rocket_thrust.stop()
	explosion_audio.play()
	is_transitioning = true
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)

func complete_level(next_level_file: String) -> void:
	rocket_thrust.stop()
	success_audio.play()
	is_transitioning = true
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
