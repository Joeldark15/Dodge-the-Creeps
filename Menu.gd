extends Control


func _ready():
	pass 



func _on_Single_Player_pressed():
		 get_tree().change_scene("res://SinglePlayer.tscn")





func _on_Local_MultiPlayer_pressed():
	 get_tree().change_scene("res://MultiPlayer.tscn")
