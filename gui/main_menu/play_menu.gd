extends Menu3D


signal cancelled()

var credits


func _process(_delta):
	if not current:
		return
	
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("cancelled")


func _on_MainMenu_menu_changed(menu):
	if menu == self:
		credits = preload("res://gui/credits/credits.tscn").instance()
		credits.connect("finished", self, "call", ["emit_signal", "cancelled"])
		add_child(credits)
	else:
		remove_child(credits)
