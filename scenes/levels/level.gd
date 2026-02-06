class_name Level extends Node2D

@export var stone_doors: Array[StoneDoor]
@export var camera: Camera2D
@export var player_spawn: Node2D
@export var spawn_at_door: StoneDoor

var player
var all_coins_collected = true

func _ready() -> void:
	for stone_door in stone_doors:
		stone_door.goto_next.connect(_on_goto_next)
	GameManager.on_pause.connect(_on_pause)
	GameManager.on_unpause.connect(_on_unpause)
	GameManager.on_all_coins_collected.connect(_on_all_coins_collected)
	await get_tree().create_timer(0.1).timeout
	all_coins_collected = false
	_start_level()
	
func _on_pause():
	HudManager.hide_hud()

func _on_unpause():
	HudManager.show_hud()

func _start_level():
	if camera:
		camera.make_current()
	if player_spawn:
		
		_spawn_door()
		AudioManager.play("RocketSwell")
		MessageManager.show_messages(["Coin Grab!", "Go!"], 1)
		
		_spawn_player()
		

func _on_all_coins_collected():
	if not all_coins_collected:
		all_coins_collected = true
		for stone_door in stone_doors:
			stone_door.open()
		
func _on_goto_next(stone_door: StoneDoor, body: Node2D):
	MessageManager.show_messages(["Next Level!"], 1)
	if body is PlatformerCharacterController:
		if body.is_player:
			body.paralyze()
			await HudManager.hide_hud()
			await get_tree().create_timer(1.0).timeout
			stone_door.close_to_next()
			await get_tree().create_timer(1.0).timeout
			SceneManager.goto_scene(stone_door.next_scene)

func _on_player_spawn(_spawn_position: Vector2):
	pass

func _on_player_die(_die_position: Vector2):
	#MessageManager.show_messages(["You Died!"], 1)
	await get_tree().create_timer(1).timeout
	player.spawn_at(player_spawn.global_position)
	
func _spawn_door():
	spawn_at_door.set_camera_priority(20)
	await get_tree().create_timer(1).timeout
	await spawn_at_door.transition_in()
	await get_tree().create_timer(1).timeout
	
func _spawn_player():
	
	await get_tree().create_timer(2.7).timeout
	player = SpawnManager.spawn("player", player_spawn.global_position, self)
	player.on_spawn.connect(_on_player_spawn)
	player.on_die.connect(_on_player_die)
	player.spawn_at(player_spawn.global_position)
	player.set_camera_priority(20)
	spawn_at_door.set_camera_priority(0)

	HudManager.show_hud()

	await get_tree().create_timer(0.5).timeout
	await spawn_at_door.close()
