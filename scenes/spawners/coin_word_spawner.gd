class_name CoinWordSpawner extends Node2D

@export var fill_words: String = ""
@export var fill_width: int = 1
@export var coin_width: int = 16
@export var letter_width: int = 4
@export var letter_spacing: int = 16

func _ready():
		_fill_words()

func _fill_words():
	var x_offset = 0
	var letters
	if fill_width == 1:
		letters = GameManager.game_data.letters_1
	else:
		letters = GameManager.game_data.letters_2
	
	for c in fill_words.to_upper():
		if c in letters:
			var pattern = letters[c]
			for y in range(pattern.size()):
				for x in range(pattern[0].size()):
					if pattern[y][x] == 1:
						var pos = Vector2(position.x + (x * coin_width) + x_offset, position.y + (y * coin_width))
						SpawnManager.spawn("coin", pos, self)
			
			x_offset += letter_width * coin_width + letter_spacing
