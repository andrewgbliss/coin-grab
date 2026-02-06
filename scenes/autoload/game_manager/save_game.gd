extends Resource
class_name SaveGame

var music_level = 50

var save_path = "user://game.save"

func load_data():
	if ResourceLoader.exists(save_path):
		return load(save_path)
	return null

func save_data(data):
	ResourceSaver.save(data, save_path)
