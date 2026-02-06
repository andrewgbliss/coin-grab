class_name Inventory extends Resource

@export var coins: int = 0

signal coins_change(amount: int)
	
func add_coins(amount: int):
	coins = coins + amount
	coins_change.emit(coins)
