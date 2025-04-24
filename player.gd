extends CharacterBody2D

@export var run_speed = 140 as float
@export var acceleration = 700 as float
@export var friction = 900 as float
@export var jump_speed = -300 as float
@export var gravity = 981 as float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var recoil_timer: Timer = $"Recoil timer"


var fireball = preload("res://fireball.tscn")

enum {IDLE, WALK, JUMP, FALL, SHOOT}
var state : int = IDLE:
	set(value):
		#if value != state:
		match state:
			IDLE:
				sprite.play("Idle")
			WALK:
				sprite.play("Walk")
			JUMP:
				sprite.play("Jump_up")
			FALL:
				sprite.play("Jump_down")
			SHOOT:
				sprite.play("Shoot_air")
		state = value

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0:
			state = JUMP
		else:
			state = FALL

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		state = JUMP
		
	var direction := Input.get_axis("joy_left", "joy_right")
	
	if Input.is_action_just_pressed("Shoot"):
		if Input.is_action_pressed("joy_down"):
			state = SHOOT
			velocity.y = -175
			var fireball_ins = fireball.instantiate()
			get_tree().current_scene.add_child(fireball_ins)
			fireball_ins.global_position = global_position
			fireball_ins.velocity = Vector2(0, 150)
			fireball_ins.vertical = true
		else:
			state = SHOOT
			velocity.x += -direction() * 9000 * delta
			var fireball_ins = fireball.instantiate()
			get_tree().current_scene.add_child(fireball_ins)
			fireball_ins.global_position = global_position
			fireball_ins.velocity = Vector2(150 * direction(), 0)
	
	if direction:
		sprite.flip_h = bool(direction < 0) #flip sprite
		velocity.x = move_toward(velocity.x ,run_speed * direction, acceleration * delta)
		if is_on_floor(): state = WALK
	elif is_on_floor(): 
		state = IDLE
		velocity.x = move_toward(velocity.x, 0, friction* delta)
	
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta * .1)
	
	move_and_slide()

#Functions start

func direction():
	return(int(sprite.flip_h)*(-2) + 1)
