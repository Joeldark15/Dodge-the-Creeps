extends Area2D
signal hit
export var speed = 400
var screen_size = Vector2(470, 720)  # Tamaño fijo de la ventana

func _ready():
	hide()

func _process(delta):
	var velocity = Vector2.ZERO

	# --- MOVIMIENTO ---
	if Input.is_action_pressed("move_rightPlayer1"):
		velocity.x += 1
	if Input.is_action_pressed("move_leftPlayer1"):
		velocity.x -= 1
	if Input.is_action_pressed("move_downPlayer1"):
		velocity.y += 1
	if Input.is_action_pressed("move_upPlayer1"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta

	# --- CONTROL DE BORDES CON TAMAÑO MÁXIMO DE SPRITE ---
	var max_sprite_size = Vector2(
		max($AnimatedSprite.frames.get_frame("walk",0).get_size().x,
			$AnimatedSprite.frames.get_frame("up",0).get_size().x),
		max($AnimatedSprite.frames.get_frame("walk",0).get_size().y,
			$AnimatedSprite.frames.get_frame("up",0).get_size().y)
	) * $AnimatedSprite.scale

	var half_w = max_sprite_size.x / 2
	var half_h = max_sprite_size.y / 2

	position.x = clamp(position.x, half_w, screen_size.x - half_w)
	position.y = clamp(position.y, half_h, screen_size.y - half_h)

	# --- ANIMACIONES ---
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_player_body_entered(_body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
