extends Node

export(PackedScene) var mob_scene
var scorePlayer1 = 0
var scorePlayer2 = 0
var players_alive = 2
var game_active = false
var zen_mode = false

var difficulty = 1
var mob_speed_min = 150
var mob_speed_max = 250
var mob_spawn_rate = 1.0

func _ready():
	randomize()
	_load_difficulty()
	new_game()


func _load_settings():
	var config = ConfigFile.new()
	if config.load("user://Settings.cfg") == OK:
		zen_mode = config.get_value("gameplay", "zen_mode", false)
		if zen_mode:
			print("Mode Zen activat")
			
func _load_difficulty():
	var config = ConfigFile.new()
	if config.load("user://Settings.cfg") == OK:
		difficulty = config.get_value("gameplay", "difficulty", 1)
	_set_difficulty()

func _set_difficulty():
	match difficulty:
		0:
			mob_speed_min = 120
			mob_speed_max = 180
			mob_spawn_rate = 1.2
		1:
			mob_speed_min = 150
			mob_speed_max = 250
			mob_spawn_rate = 1.0
		2:
			mob_speed_min = 200
			mob_speed_max = 320
			mob_spawn_rate = 0.6

func game_over(player_number):
	if game_active:
		players_alive -= 1
		$DeathSound.play()

		if player_number == 1:
			$ScoreTimer.stop()
		else:
			$ScoreTimer2.stop()

		if players_alive <= 0:
			game_active = false
			$Music.stop()
			$MobTimer.stop()
			$StartTimer.stop()
			$HUD.show_game_over()
			$HUD2.show_game_over()

			var mensaje = ""
			if scorePlayer1 > scorePlayer2:
				mensaje = "Player 1 Wins!"
			elif scorePlayer2 > scorePlayer1:
				mensaje = "Player 2 Wins!"
			else:
				mensaje = "Draw!"

			$HUD.show_message(mensaje)
			$HUD2.show_message(mensaje)

			yield(get_tree().create_timer(2.0), "timeout")
			get_tree().change_scene("res://Menu.tscn")

func new_game():
	scorePlayer1 = 0
	scorePlayer2 = 0
	players_alive = 2
	game_active = true

	$Music.play()

	$HUD.update_score(scorePlayer1)
	$HUD2.update_score(scorePlayer2)

	$HUD.show_message("Get Ready")
	$HUD2.show_message("Get Ready")

	$player.start($StartPosition.position)
	$player2.start($StartPosition2.position)

	get_tree().call_group("mobs", "queue_free")

	$StartTimer.start()

func _on_ScoreTimer_timeout():
	if game_active:
		scorePlayer1 += 1
		$HUD.update_score(scorePlayer1)

func _on_ScoreTimer2_timeout():
	if game_active:
		scorePlayer2 += 1
		$HUD2.update_score(scorePlayer2)

func _on_StartTimer_timeout():
	if game_active:
		$MobTimer.wait_time = mob_spawn_rate
		$MobTimer.start()
		$ScoreTimer.start()
		$ScoreTimer2.start()

func _on_MobTimer_timeout():
	if game_active:
		var mob = mob_scene.instance()
		var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
		mob_spawn_location.offset = randi()

		var direction = mob_spawn_location.rotation + PI / 2
		mob.position = mob_spawn_location.position
		direction += rand_range(-PI / 4, PI / 4)
		mob.rotation = direction

		var speed = rand_range(mob_speed_min, mob_speed_max)
		var velocity = Vector2(speed, 0.0)
		mob.linear_velocity = velocity.rotated(direction)

		add_child(mob)

func _on_player_hit():
	game_over(1)

func _on_player2_hit():
	game_over(2)

func _on_Button_pressed():
	get_tree().change_scene("res://Menu.tscn")
