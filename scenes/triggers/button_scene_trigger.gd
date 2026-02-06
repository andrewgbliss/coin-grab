class_name ButtonSceneTrigger extends Button

@export var scene_path: String

func _ready() -> void:
	pressed.connect(_button_pressed)
	
func _button_pressed() -> void:
	SceneManager.goto_scene(scene_path)
