extends Spatial


signal menu_changed(menu)

onready var current_menu = $Menu setget set_current_menu
onready var tween: Tween = $Tween
onready var camera: Camera = $Camera


func set_current_menu(value):
	if current_menu:
		current_menu.current = false
	if value:
		value.current = true
	current_menu = value
	emit_signal("menu_changed", current_menu)


func _ready():
	OS.window_maximized = true
	self.current_menu = $Menu
	
	for barrel in get_tree().get_nodes_in_group("floating_barrels"):
		if barrel is RigidBody:
			barrel.mode = RigidBody.MODE_STATIC
	
	$Barrel.laughing = true


func _on_Menu_credits_selected():
	self.current_menu = null
	tween.stop_all()
	tween.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees,
			Vector3(90, -90, 0), 0.75, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	self.current_menu = $CreditsMenu


func _on_CreditsMenu_cancelled():
	self.current_menu = null
	tween.stop_all()
	tween.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees,
			Vector3(0, -90, 0), 0.75, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	self.current_menu = $Menu
		
