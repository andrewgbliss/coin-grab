class_name DeathZone extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is PlatformerCharacterController:
		if body.is_alive:
			body.die()
