extends Spatial


onready var player = $Player

var countdown_completed := false


func reset():
	player.eyes.disabled = true
	player.label.clear()
	player.label.bbcode_text = "[center]NO PEEKING![/center]"
	
	if player.eyes.eyes_open:
		player.eyes.close_eyes()
		yield(player.eyes, "closed")
	
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://levels/tutorial/tutorial_part2a.tscn")


func _on_Area_body_entered(body):
	if body is Player and not countdown_completed:
		reset()


func _on_Player_countdown_completed():
	countdown_completed = true
	
	player.label.clear()
	player.label.bbcode_text = """
		[center]FIND MOPSA. IF YOU CLICK ON THE WRONG BARREL, MOPSA WILL GIGGLE, GIVING AWAY HER LOCATION.[/center]
	"""


func _on_Mopsa_Found():
	player.label.clear()
	player.label.bbcode_text = "[center]CONGRATULATIONS![/center]"
	yield(get_tree().create_timer(2), "timeout")
	player.eyes.disabled = true
	player.eyes.close_eyes()
	yield(player.eyes, "closed")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://levels/tutorial/tutorial_part2b.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://gui/main_menu/main_menu.tscn")
