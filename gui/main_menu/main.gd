extends Menu3D

signal credits_selected()


func accept():
	if not current:
		return
	
	match selected_index:
		0:
			get_tree().change_scene("res://levels/tutorial/tutorial_part1.tscn")
		1:
			get_tree().change_scene("res://levels/sandy_snickers/sandy_snickers.tscn")
		2:
			emit_signal("credits_selected")
		3:
			get_tree().quit(0)
		_:
			Sounds.play_wrong()
	


func _process(_delta):
	if not current:
		return
	
	if Input.is_action_just_pressed("ui_down"):
		self.selected_index = min(3, (selected_index + 1))
	elif Input.is_action_just_pressed("ui_up"):
		self.selected_index = max(0, (selected_index - 1))
	elif Input.is_action_just_pressed("ui_accept"):
		accept()
