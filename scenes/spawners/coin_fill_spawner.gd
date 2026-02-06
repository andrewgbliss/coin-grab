class_name CoinFillSpawner extends Node2D

@export var tile_map_layer: TileMapLayer
@export var coin_height: int = 10

func _ready():
	_fill_in_empty_space()

func _fill_in_empty_space():
	var bounds = tile_map_layer.get_used_rect()
	for x in range(bounds.position.x, bounds.position.x + bounds.size.x):
		for y in range(bounds.position.y, bounds.position.y + bounds.size.y):
			var pos = Vector2i(x, y)
			if tile_map_layer.get_cell_source_id(pos) == -1:
				var has_ground = false
				for i in range(1, coin_height):
					var check_pos = Vector2i(x, y + i)
					if tile_map_layer.get_cell_source_id(check_pos) != -1:
						has_ground = true
				
				if has_ground:
					SpawnManager.spawn("coin", tile_map_layer.map_to_local(pos), self)
