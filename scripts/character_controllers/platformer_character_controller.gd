class_name PlatformerCharacterController extends CharacterBody2D

@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D
@export var controls: CharacterControls
@export var collision_shape: CollisionShape2D

@export_category("Movement")
@export var walk_speed = 150.0
@export var run_speed = 300.0
@export var push_force: float = 100
@export var acceleration: float = 75
@export var friction: float = 50
@export var max_velocity: Vector2 = Vector2(1000, 1000)

@export_category("Jump")
@export var jump_velocity = -400
@export var jumps = 2

@export_category("Gravity")
@export var gravity_percent: float = 1.3
@export var use_gravity: bool = true

@export_category("Animation")
@export var animation_names: Dictionary[String, String] = {
	"idle": "idle",
	"walk": "walk",
	"run": "run",
	"jump": "jump",
	"land": "land",
	"fall": "fall"
}

@export_category("Sound FX")
@export var sound_fx_names: Dictionary[String, String] = {
	"jump": "Jump,Jump2,Jump3,Jump4",
}

@export_category("Inventory")
@export var inventory: Inventory

@export_category("Data")
@export var is_player: bool = false
@export var phantom_camera : PhantomCamera2D

@export_category("State")
@export var state_machine: StateMachine

signal on_spawn(spawn_position: Vector2)
signal on_die(die_position: Vector2)

var jumps_left = 0
var facing_right_modifier: int = 1
var speed
var is_jumping: bool = false
var is_falling: bool = false
var spawn_position: Vector2
var is_paralyzed = false
var is_facing_right: bool = true
var is_alive: bool = false

func _ready():
	sprite.hide()
	#collision_shape.disabled = true
	if is_player and inventory != null:
		inventory.coins_change.connect(HudManager.set_coins)

func paralyze():
	is_paralyzed = true

func move(delta: float) -> Vector2:
	_apply_gravity(delta)
	
	if is_alive:
		_apply_controls()
		
	_clamp_velocity()
	_handle_flip()
	
	if move_and_slide():
		_handle_collisions()

	return velocity

func _clamp_velocity():
	velocity.y = clamp(velocity.y, -max_velocity.y, max_velocity.y)
	velocity.x = clamp(velocity.x, -max_velocity.x, max_velocity.x)

func _handle_collisions():
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		
		_resolve_collision(col)
		
		var collider = col.get_collider()
					
		# Handle collision damage from enemies
		#var collision = get_last_slide_collision()
		#var collider = collision.get_collider()
		#if collider.is_in_group("enemy"):
			#take_damage_from_node(collider)
		
		# Handle rigid bodies
		if collider is RigidBody2D:
			collider.apply_force(col.get_normal() * -push_force)
	
func _handle_flip():
	if controls and controls.mouse_look:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.x < position.x:
			is_facing_right = false
			scale.x = scale.y * -facing_right_modifier
		else:
			is_facing_right = true
			scale.x = scale.y * facing_right_modifier
		return
			
#	Use velocity to determine what way is facing
	if velocity.x > 0:
		is_facing_right = true
		scale.x = scale.y * facing_right_modifier
	elif velocity.x < 0:
		is_facing_right = false
		scale.x = scale.y * -facing_right_modifier
		
func _resolve_collision(collision):
	var normal = collision.get_normal()
	var depth = collision.get_depth()
	var travel = collision.get_travel()

	# Calculate the movement needed to resolve the collision
	var move_amount = normal * depth

	# Adjust position considering the original travel direction (optional)
	global_position += move_amount + (travel * 0.1) # Adjust the factor as needed
	
func _apply_gravity(delta: float):
	if use_gravity and not is_on_floor():
		velocity += (get_gravity() * gravity_percent) * delta
			
func _apply_controls():
	if is_paralyzed:
		velocity.x = 0
		return
		
	speed = 0
	if controls.is_walking():
		speed = walk_speed
	elif controls.is_running():
		speed = run_speed

	var direction = controls.get_movement_direction()
	
	if controls.lock_x_controls:
		if direction.x != 0:
			velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction)
		return
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)

func jump():
	if is_paralyzed:
		return
	is_jumping = true
	jumps_left -= 1
	velocity.y = jump_velocity
	AudioManager.play_random(sound_fx_names['jump'].split(","))
	if move_and_slide():
		_handle_collisions()
	
func jump_released():
	if not controls.is_jump_pressed() and is_jumping:
		is_jumping = false
		animation_player.play(animation_names["fall"])
		velocity.y = 0
		return true
	return false
	
func landed():
	if is_on_floor():
		is_falling = false;
		jumps_left = jumps
		animation_player.play(animation_names["land"])
		state_machine.dispatch("land")
		return true
	return false
		
func falling():
	if velocity.y > 0:
		is_falling = true;
		is_jumping = false;
		animation_player.play(animation_names["fall"])
		return true
	return false

func die(free = false):
	if is_alive:
		is_alive = false
		on_die.emit(position)
		if free:
			queue_free()
	
func spawn():
	velocity = Vector2.ZERO
	sprite.show()
	on_spawn.emit(position)
	is_alive = true
	is_paralyzed = false
	
func spawn_at(new_spawn_position: Vector2):
	spawn_position = new_spawn_position
	position = spawn_position
	spawn()

func set_camera_priority(priority):
	phantom_camera.set_priority(priority)
	
func move_to(direction, delta):
	velocity = direction * walk_speed
	_handle_flip()
	var collision = move_and_collide(velocity * delta)
	if collision:
		_handle_collision(collision)
	return collision
	
func _handle_collision(collision):
	var explosion = SpawnManager.spawn("small_explosion", collision.get_position())
	explosion.explode()
	var body = collision.get_collider()
	if body is PlatformerCharacterController:		
		body.die()
	if inventory.coins > 0:
		for i in range(0, inventory.coins):
			SpawnManager.spawn("coin", collision.get_position())
	die(true)
	
