extends Node

var save_file_path = "user://save/"
var save_file_name = "GameData.tres"

var game_data: GameData = GameData.new()

signal on_game_over
signal on_game_win
signal on_pause
signal on_unpause
signal on_toggle_mobile_controls
signal on_all_coins_collected

func _ready():
	verify_save_dir(save_file_path)
	if not FileAccess.file_exists(save_file_path + save_file_name):
		save_game_data()
	load_game_data()
	set_window_min_size()
	
func set_window_min_size() -> void:
	var min_size = Vector2.ZERO
	min_size.x = ProjectSettings.get_setting('display/window/size/viewport_width')
	min_size.y = ProjectSettings.get_setting('display/window/size/viewport_height')
	get_window().min_size = min_size

func verify_save_dir(path):
	DirAccess.make_dir_absolute(path)
	
func save_game_data():
	var file = FileAccess.open(save_file_path + save_file_name, FileAccess.WRITE)
	var json_string = JSON.stringify(game_data.save())
	file.store_string(json_string)
	file.close()

func load_game_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		var file = FileAccess.open(save_file_path + save_file_name, FileAccess.READ)
		var json_string = file.get_as_text()
		var parse_res = JSON.parse_string(json_string)
		if parse_res:
			game_data = GameData.new()
			game_data.load(parse_res)
		else:
			print("Failed to parse game data")
		file.close()
	else:
		print("Failed to load game data")

func get_json_from_file(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		var parse_res = JSON.parse_string(json_string)
		return parse_res
	else:
		return null

func pause():
	get_tree().paused = true
	on_pause.emit()

func unpause():
	get_tree().paused = false
	on_unpause.emit()

func quit():
	get_tree().quit()

func game_win():
	on_game_win.emit()

func game_over():
	on_game_over.emit()

func toggle_mobile_controls(value: bool):
	print("value", value)
	game_data.show_mobile_controls = value
	on_toggle_mobile_controls.emit(value)
	save_game_data()
	
func check_all_coins():
	await get_tree().create_timer(1.0).timeout
	var nodes = get_tree().get_nodes_in_group("coin")
	if nodes.size() <= 1:
		GameManager.on_all_coins_collected.emit()
