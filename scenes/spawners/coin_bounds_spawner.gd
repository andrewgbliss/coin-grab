class_name CoinBoundsSpawner extends Node2D

@export var width: int = 64
@export var height: int = 64
@export var padding: int = 16

func _ready():
	_fill()

func _fill():
	for x in range(0, width, padding):
		for y in range(0, height, padding):
			var pos = Vector2i(x, y)
			SpawnManager.spawn("coin", pos, self)
