extends AudioStreamPlayer3D


var phrases = {
	"hey_no_peeking": [
		preload("res://characters/mopsa/assets/final/hey_no_peeking_0.wav"),
		preload("res://characters/mopsa/assets/final/hey_no_peeking_1.wav"),
		preload("res://characters/mopsa/assets/final/hey_no_peeking_2.wav"),
		preload("res://characters/mopsa/assets/final/hey_no_peeking_3.wav"),
	],
	"you_found_me": [
		preload("res://characters/mopsa/assets/final/you_found_me_0.wav"),
		preload("res://characters/mopsa/assets/final/you_found_me_1.wav"),
	],
	"giggle": [
		preload("res://characters/mopsa/assets/final/giggle_0.wav")
	],
}


func _ready():
	Events.connect("player_guessed_wrong", self, "say", ["giggle"])


func say(what: String, immediate: bool = false) -> void:
	if what == "giggle" and get_parent().visible:
		return
	
	if not phrases.has(what):
		push_warning("Unknown phrase: '%s'. Remaining silent" % what)
		return
	
	if playing and not immediate:
		yield(self, "finished")
	else:
		stop()
	
	var selected = phrases[what]
	
	if selected is Array:
		stream = selected[randi() % selected.size()]
	else:
		stream = selected
	
	play()
