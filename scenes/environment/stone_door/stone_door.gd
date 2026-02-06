class_name StoneDoor extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var stone_sprite: Sprite2D
@export var frame_sprite: Sprite2D
@export var next_scene: String
@export var phantom_camera : PhantomCamera2D

var is_open = false

signal goto_next(stone_door: StoneDoor, body: Node2D)

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D):
	if body is PlatformerCharacterController:
		if body.is_player and is_open:
			goto_next.emit(self, body)
			
func transition_in():
	animation_player.play("transition_in")
	await animation_player.animation_finished

func transition_out():
	animation_player.play("transition_out")
	await animation_player.animation_finished

func open():
	animation_player.play("open")
	await animation_player.animation_finished
	is_open = true

func close():
	animation_player.play("close")
	await animation_player.animation_finished
	is_open = false
	
func close_to_next():
	stone_sprite.z_index = 100
	frame_sprite.z_index = 101
	close()
	
func set_camera_priority(priority):
	phantom_camera.set_priority(priority)
