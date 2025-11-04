extends CanvasLayer

signal start_game

func _ready():
	if has_node("StartButton"):
		$StartButton.hide()

func show_message(text):
	print(text)
	$Missatge.text = text
	$Missatge.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	$Missatge.text = "Dodge the\nCreeps!"
	$Missatge.show()


func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	# Solo ocultar si existe (por seguridad)
	if has_node("StartButton"):
		$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Missatge.hide()
