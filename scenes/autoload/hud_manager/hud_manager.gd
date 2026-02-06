extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var virtual_joystick: Control
@export var mobile_buttons: Control
@export var coins_label: Label
@export var seconds_label: Label

func _ready():
	if GameManager.game_data.first_time_loaded and OS.get_name() == "Android":
		GameManager.toggle_mobile_controls(true)
		
	if not GameManager.game_data.show_mobile_controls:
		virtual_joystick.hide()
		mobile_buttons.hide()
		
	GameManager.on_toggle_mobile_controls.connect(_on_toggle_mobile_controls)

func _process(_delta: float) -> void:
	if seconds_label:
		seconds_label.text = "%.2f" % (Time.get_ticks_msec() / 1000.0)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("pause"):
			_on_pause()

func _on_toggle_mobile_controls(value: bool):
	if value:
		virtual_joystick.show()
		mobile_buttons.show()
	else:
		virtual_joystick.hide()
		mobile_buttons.hide()

func set_coins(coins: int):
	if coins_label:
		coins_label.text = "$ " + str(coins)

func show_hud():
	animation_player.play("transition_in")
	await animation_player.animation_finished

func hide_hud():
	animation_player.play("transition_out")
	await animation_player.animation_finished

func _on_pause() -> void:
	if get_tree().paused:
		GameManager.unpause()
		await MenuManager.pop_all()
	else:
		GameManager.pause()
		await MenuManager.push("PauseMenu")

func _on_jump_touch_screen_button_pressed() -> void:
	var a = InputEventAction.new()
	a.action = "jump"
	a.pressed = true
	Input.parse_input_event(a)

func _on_jump_touch_screen_button_released() -> void:
	var a = InputEventAction.new()
	a.action = "jump"
	a.pressed = false
	Input.parse_input_event(a)


func _on_home_button_pressed() -> void:
	_on_pause()

func _on_run_touch_screen_button_pressed() -> void:
	var a = InputEventAction.new()
	a.action = "run"
	a.pressed = true
	Input.parse_input_event(a)
	
func _on_run_touch_screen_button_released() -> void:
	var a = InputEventAction.new()
	a.action = "run"
	a.pressed = false
	Input.parse_input_event(a)
