extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var message_text: Label

var is_showing_message: bool = false

func _show_message():
	if not is_showing_message:
		is_showing_message = true
		animation_player.play("message_text_in")
		await animation_player.animation_finished

func _set_message(message: String):
	message_text.text = message

func show_messages(messages: Array[String], duration: float):
	for message in messages:
		_set_message(message)
		await _show_message()
		await get_tree().create_timer(duration).timeout
			
	_hide_message()

func _hide_message():
	animation_player.play("message_text_out")
	await animation_player.animation_finished
	message_text.text = ""
	is_showing_message = false
