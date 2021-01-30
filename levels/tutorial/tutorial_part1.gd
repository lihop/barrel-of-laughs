extends Spatial


onready var player = $Player


func _ready():
	player.label.clear()
	player.label.bbcode_text = """
		[center]HOLD SPACE TO CLOSE YOUR EYES AND COUNTDOWN FROM %d SO MOPSA CAN HIDE.
		NO PEEKING![/center]
	""" % player.countdown


func _on_Player_countdown_completed():
	player.label.clear()
	player.label.bbcode_text = """
		[center]FIND MOPSA. WALK UP TO A BARREL AND CLICK IT TO CHECK IF MOPSA IS HIDING THERE.[/center]
	"""


func _on_Mopsa_Found():
	player.label.clear()
	player.label.bbcode_text = "[center]CONGRATULATIONS![/center]"
	yield(get_tree().create_timer(2), "timeout")
	player.eyes.disabled = true
	player.eyes.close_eyes()
	yield(player.eyes, "closed")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://levels/tutorial/tutorial_part2a.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://gui/main_menu/main_menu.tscn")
