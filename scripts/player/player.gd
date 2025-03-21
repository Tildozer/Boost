extends RigidBody3D

## How much verticle force is applied when moving
@export_range(100.0, 5000.0) var thrust: float = 1000.0

## How much torque applied to player when rotating
@export_range(50.0, 500.0) var torque_thrust: float = 100.0

var is_transitioning: bool = false

#Audio$explosionParticles
@onready var explosion_audio: AudioStreamPlayer = $explosionAudio
@onready var success_audio: AudioStreamPlayer = $successAudio
@onready var rocket_thrust: AudioStreamPlayer3D = $rocketAudio
#Particles
@onready var thruster_particles: GPUParticles3D = $boosterParticles
@onready var right_thruster_particles: GPUParticles3D = $rightBoosterParticles
@onready var left_thruster_particles: GPUParticles3D = $leftBoosterParticles
@onready var explosion_particles :GPUParticles3D = $explosionParticles
@onready var success_particles :GPUParticles3D = $successParticles

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		thruster_particles.emitting = true
		if !rocket_thrust.playing:
			rocket_thrust.play()
	else:
		thruster_particles.emitting = false
		rocket_thrust.stop()
	
	if Input.is_action_pressed("rotate_left"):
		left_thruster_particles.emitting = true
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	else: 
		left_thruster_particles.emitting = false
	
	if Input.is_action_pressed("rotate_right"):
		right_thruster_particles.emitting = true
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
	else:
		right_thruster_particles.emitting = false
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_body_entered(body: Node) -> void:
	if !is_transitioning:
		if "goal" in body.get_groups():
			call_deferred("complete_level", body.file_path)
		if "obstacle" in body.get_groups():
			call_deferred("crash_sequence")

func crash_sequence() -> void:
	explosion_particles.emitting = true
	explosion_audio.play()
	stop_thrust_effects()
	is_transitioning = true
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)

func complete_level(next_level_file: String) -> void:
	success_particles.emitting = true
	success_audio.play()
	stop_thrust_effects()
	is_transitioning = true
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)

func stop_thrust_effects() -> void:
	rocket_thrust.stop()
	thruster_particles.emitting = false
