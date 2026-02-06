extends Node2D

@export var animation_player : AnimationPlayer

func explode() -> void:
	animation_player.play("explode")
	await animation_player.animation_finished
	queue_free()
