extends Control


signal closed()
signal opened()

export var eyes_open := true
export var disabled := false

onready var eyelids:  Light2D = $Eyelids
onready var tween: Tween = $Tween


func _ready():
	center_eyelids()
	if eyes_open:
		eyelids.scale.y = 150
	else:
		eyelids.scale.y = 0


func _process(_delta):
	if not disabled:
		if Input.is_action_just_pressed("close_eyes"):
			close_eyes()
		
		elif Input.is_action_just_released("close_eyes"):
			open_eyes()
	
	if not eyes_open and eyelids.scale.y > 3:
		eyes_open = true
		Logger.info("Player opened eyes")
		emit_signal("opened")
	elif eyes_open and eyelids.scale.y < 0.75:
		eyes_open = false
		Logger.info("Player closed eyes")
		emit_signal("closed")


func center_eyelids():
	eyelids.position = get_viewport_rect().size / 2


func close_eyes():
	tween.stop_all()
	tween.interpolate_property(eyelids, "scale",
			eyelids.scale, Vector2(150, 0), 1.25,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1.25), "timeout")
	if eyelids.scale.y < 1.2 and eyes_open:
		eyes_open = false
		Logger.info("Player closed eyes")
		emit_signal("closed")


func open_eyes():
	tween.stop_all()
	tween.interpolate_property(eyelids, "scale",
			eyelids.scale, Vector2(150, 150), 1.25,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1.25), "timeout")
	if eyelids.scale.y > 1.5 and not eyes_open:
		eyes_open = true
		Logger.info("Player opened eyes")
		emit_signal("opened")


func _on_Control_resized():
	if eyelids:
		center_eyelids()
