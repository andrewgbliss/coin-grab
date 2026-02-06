class_name Coin extends Area2D

@export var item_base: ItemBase

func _on_body_entered(body: Node2D) -> void:
	if body is PlatformerCharacterController:
		if body.is_alive and body.inventory != null:
			if item_base.item is Money:
				body.inventory.add_coins(item_base.item.amount)
				AudioManager.play_random(["PickupCoin", "PickupCoin2", "PickupCoin3"])
				GameManager.check_all_coins()
				queue_free()
				
	
