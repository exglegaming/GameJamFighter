extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var minimalJumpVelocity:float = -100
@export var fallGravityMultiplier:float = 2
@export var acceleration: float = 1500
@export var friction: float = 1200
@export var coyoteTime:float = 0.15
@export var jumpBufferTime:float = 0.1
var CoyoteTimer:float = 0
var BufferTimer:float = 0

@export_category("Weapon")
@export var weapon_ammo:Array = [0,6,3] # ammo the weapon has right now, there is no cap on ammo
@export var projectile_container:Node # assigned in the main scene inspector
@export var projectile:PackedScene

var number_colliding_bodies := 0
var is_attacking: bool = false
var imunityTime:float = 0.6
var base_damage: float = 5
var weapon: int = 0
var didHitGround: bool = true

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var visuals: Node2D = $Visuals
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/CollisionShape2D


func _ready() -> void:
	$HurtBox.body_entered.connect(on_body_entered)
	$HurtBox.body_exited.connect(on_body_exited)
	anim_sprite.animation_finished.connect(on_animation_finished)
	damage_interval_timer.timeout.connect(damageIntervalEnded)


func _process(delta: float) -> void:
	if is_on_floor():
		if didHitGround == false:
			SoundEffectsPlayer.play_jump_end()
			didHitGround = true

		CoyoteTimer = coyoteTime
	else:
		didHitGround = false
		var Gravity: float = get_gravity().y * delta

		CoyoteTimer -= delta
		BufferTimer -= delta
		if velocity.y >= 0 :
			var fallVelocity = get_gravity().y * delta * fallGravityMultiplier
			Gravity = fallVelocity
		velocity.y += Gravity
	if !is_attacking:
		if Input.is_action_just_pressed(GameConstants.JUMP):
			if CoyoteTimer > 0:
				velocity.y = jump_velocity
				CoyoteTimer = 0
				SoundEffectsPlayer.play_jump() 
			else :
				BufferTimer = jumpBufferTime
		if is_on_floor() and BufferTimer > 0:
			velocity.y = jump_velocity
			BufferTimer = 0


	if Input.is_action_just_released(GameConstants.JUMP) and !is_on_floor() and velocity.y <= minimalJumpVelocity:
		velocity.y = minimalJumpVelocity

	if Input.is_action_just_pressed(GameConstants.ATTACK) and not is_attacking:
		is_attacking = true
		attack()
		await get_tree().create_timer(0.3).timeout
		SoundEffectsPlayer.play_sound("sword_attack")
	
	if Input.is_action_just_pressed("switch_attack"):
		switch_weapon()

	var direction: float = get_direction()
	if !is_attacking:
		if direction != 0:
			velocity.x = move_toward(velocity.x , direction * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
	update_animations(direction)


func get_direction() -> float:
	return Input.get_axis(GameConstants.MOVE_LEFT, GameConstants.MOVE_RIGHT)


func update_animations(direction: float) -> void:
	if is_attacking:
		return

	if direction > 0:
		visuals.scale.x = 1
		hitbox_component.scale.x = 1
	elif direction < 0:
		visuals.scale.x = -1
		hitbox_component.scale.x = -1

	if !is_on_floor():
		if velocity.y <= 0 :
			anim_sprite.play(GameConstants.JUMPING)
		elif velocity.y > 0 :
			anim_sprite.play(GameConstants.FALLING)
	else :
		if abs(velocity.x) > 5 :
			anim_sprite.play(GameConstants.WALK)
		else:
			anim_sprite.play(GameConstants.IDLE)

func attack() -> void:
	print("attack")
	anim_sprite.play(GameConstants.SLASH)
	hitbox_component.damage = base_damage

	await get_tree().create_timer(0.4).timeout
	if is_attacking:
		match weapon:
			0:
				hitbox_collision.disabled = false
			1:
				throwing_attack()
			2:
				dash_attack()


#region funcs for handling different attacks
# cycle between different weapons
func switch_weapon() -> void:
	weapon = (weapon + 1) % weapon_ammo.size() # add new item to weapon_ammo array to add new weapon
	print("current weapon: " + str(weapon))
	

# throws a projectile
func throwing_attack():
	if weapon_ammo[1] > 0:
		weapon_ammo[1] -= 1
		var bullet:RigidBody2D = projectile.instantiate()
		bullet.position = Vector2(position.x, position.y-10)
		projectile_container.add_child(bullet)
		# make the bullet do damage
		var bullet_hitbox:HitboxComponent = bullet.get_node_or_null("HitboxComponent")
		if bullet_hitbox:
			bullet_hitbox.damage = base_damage

		var impulse = Vector2(sign(visuals.scale.x),-1) # up is -1 here
		bullet.apply_impulse(impulse*350)


func dash_attack():
	if weapon_ammo[2] > 0:
		weapon_ammo[2] -= 1
		hitbox_collision.disabled = false
		velocity.x = sign(visuals.scale.x) * 800
#endregion
# returns the current health of player
func get_current_health() -> int:
	return int(health_component.current_health)
	
func on_animation_finished() -> void:
	if anim_sprite.animation == GameConstants.SLASH:
		is_attacking = false
		hitbox_collision.disabled = true


func check_deal_damage() -> void:
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start(imunityTime)

func damageIntervalEnded() -> void:
	check_deal_damage()

func on_body_entered(other_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D) -> void:
	number_colliding_bodies -= 1
