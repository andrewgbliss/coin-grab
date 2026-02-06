class_name GroundState extends State

func process_physics(delta: float) -> void:
	if parent.use_gravity and parent.falling():
		state_machine.dispatch("falling")
		return
	var velocity = parent.move(delta)
	resolve_animations(velocity)
	
func resolve_animations(velocity: Vector2):
	if parent.is_jumping or parent.is_falling:
		return
	if Vector2.ZERO.is_equal_approx(velocity):
		parent.animation_player.play(parent.animation_names["idle"])
	elif parent.controls.is_walking():
		parent.animation_player.play(parent.animation_names["walk"])
	elif parent.controls.is_running():
		parent.animation_player.play(parent.animation_names["run"])
