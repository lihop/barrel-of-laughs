extends Spatial


onready var player = $Player
onready var mopsa = $Mopsa
onready var barrels_remaining = get_tree().get_nodes_in_group("hiding_spots").size()


func _ready():
	player.barrels_label.text = "BARRELS REMAINING: %d" % barrels_remaining
	
	while true:
		yield(get_tree().create_timer(5), "timeout")
		for spot in get_tree().get_nodes_in_group("hiding_spots"):
			if not spot.laughing:
				spot.laughing = true
				break


func _on_Mopsa_Found():
	barrels_remaining -= 1
	player.barrels_label.text = "BARRELS REMAINING: %d" % barrels_remaining
	if barrels_remaining == 0:
		player.label.clear()
		player.label.bbcode_text = "[center]CONGRATULATIONS! LEVEL COMPLETE![/center]"
		Sounds.play_level_complete()
		yield(get_tree().create_timer(5), "timeout")
		get_tree().change_scene("res://gui/main_menu/main_menu.tscn")
	else:
		player.label.clear()
		player.label.bbcode_text = "[center]CONGRATULATIONS![/center]"
		Sounds.play_congratulations()
		player.reset()
		mopsa.Reset()
		player.label.bbcode_text = "HOLD SPACE TO CLOSE YOUR EYES AND COUNT DOWN FROM %d" % player.countdown


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://gui/main_menu/main_menu.tscn")
