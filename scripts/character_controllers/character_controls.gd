class_name CharacterControls extends Node

@export var mouse_look: bool = false
@export var allow_y_controls: bool = false
@export var lock_x_controls: bool = false
@export var walking_full_speed_time_threshold: float = 1
@export var state_machine: StateMachine

var parent: PlatformerCharacterController
var direction: Vector2
var walking_full_speed_time: float = 0

func _ready():
	parent = get_parent()

func _input(_event: InputEvent) -> void:
	if is_jump_just_pressed():
		if parent.jumps_left > 0:
			parent.jump()
			state_machine.dispatch("jump")

#func _process(delta: float) -> void:
	#if is_walking_full_speed():
		#walking_full_speed_time += delta
	#if direction == Vector2.ZERO:
		#walking_full_speed_time = 0

func get_movement_direction():
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return direction

func is_walking() -> bool:
	return not Input.is_action_pressed("run") and direction != Vector2.ZERO

#func is_walking_full_speed() -> bool:
	#return is_walking() and abs(direction.x) > .75

func is_running() -> bool:
	return (Input.is_action_pressed("run") and direction != Vector2.ZERO)

func is_jump_just_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

func is_jump_pressed() -> bool:
	return Input.is_action_pressed("jump")
#
#func has_been_walking_full_speed() -> bool:
	#return walking_full_speed_time > walking_full_speed_time_threshold
