extends Area2D
signal hit
export var speed = 400
var screen_size
var zen_mode = false

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	_load_settings()

func _load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		zen_mode = config.get_value("gameplay", "zen_mode", false)

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_rightPlayer2"):
		velocity.x += 1
	if Input.is_action_pressed("move_leftPlayer2"):
		velocity.x -= 1
	if Input.is_action_pressed("move_downPlayer2"):
		velocity.y += 1
	if Input.is_action_pressed("move_upPlayer2"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_player2_body_entered(_body):
	if zen_mode:
		return
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
