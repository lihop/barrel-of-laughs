extends Player


signal countdown_completed()

export var countdown := 5

var ready := false

onready var timer: Timer = $Timer
onready var label: RichTextLabel = $CanvasLayer/Control/RichTextLabel
onready var barrels_label: Label = $CanvasLayer/Control/BarrelsLabel
onready var timer_label: Label = $CanvasLayer/Control/TimerLabel
onready var eyes := $Eyes


func reset():
	ready = false
	timer.stop()


func _ready():
	._ready()
	
	eyes.disabled = true
	eyes.open_eyes()
	yield(eyes, "opened")
	eyes.disabled = false

	timer.wait_time = countdown
	label.bbcode_text = "[center]HOLD SPACE TO CLOSE YOUR EYES AND COUNTDOWN FROM %d[/center]" % countdown
	
	Events.connect("hider_found", self, "_on_hider_found")
	

func _process(_delta):
	if not timer.is_stopped() and not eyes.disabled:
		timer_label.text = "%.2f" % timer.time_left


func _on_Eyes_opened():
	Events.emit_signal("player_opened_eyes")
	if not ready:
		timer.stop()


func _on_Eyes_closed():
	Events.emit_signal("player_closed_eyes")
	if not ready:
		timer.start()


func _on_Timer_timeout():
	ready = true
	timer_label.text = ""
	label.bbcode_text = "[center]FIND MOPSA[/center]"
	Logger.info("Ready or not here I come!")
	emit_signal("countdown_completed")
	Events.emit_signal("countdown_completed")
