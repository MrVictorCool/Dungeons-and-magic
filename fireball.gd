extends Area2D
@export var initial_velocity: Vector2 = Vector2(120, 0)
@export var drag: float = 20
@export var vertical := false:
	set(value):
		if value == true:
			rotation = PI/2
		else: rotation = 0
		vertical = value


var velocity := Vector2.ZERO

func _ready() -> void:
	velocity = initial_velocity

func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, drag * delta)
	velocity.y = move_toward(velocity.y, 0, drag * delta)
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	global_position += velocity * delta
	if velocity.y > 0:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false

func _on_timer_timeout() -> void:
		queue_free()
