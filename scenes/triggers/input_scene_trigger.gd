class_name InputSceneTrigger extends Node

@export var scene_path: String

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_anything_pressed() or event is InputEventMouseButton and event.is_pressed():
		SceneManager.goto_scene(scene_path)
