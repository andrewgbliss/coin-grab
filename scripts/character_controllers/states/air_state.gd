class_name AirState extends State

func process_physics(delta: float) -> void:
	if parent.use_gravity:
		parent.landed()
		parent.jump_released()
		parent.falling()
	var velocity = parent.move(delta)
