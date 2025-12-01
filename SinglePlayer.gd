extends Node
export(PackedScene) var mob_scene
var score = 0
var zen_mode = false

func _ready():
	randomize()
	_load_settings()
	new_game()

func _load_settings():
	var config = ConfigFile.new()
	if config.load("user://Settings.cfg") == OK:
		zen_mode = config.get_value("gameplay", "zen_mode", false)
		if zen_mode:
			print("Mode Zen activat")

func game_over():
	if zen_mode:
		return
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Menu.tscn")

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)


func _on_Button_pressed():
	 get_tree().change_scene("res://Menu.tscn")
