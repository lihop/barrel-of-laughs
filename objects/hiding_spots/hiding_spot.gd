extends StaticBody
class_name HidingSpot


signal frobbed()

var user: KinematicBody = null
var discovered = false

var smoke_bomb: Particles = preload("res://objects/special_effects/smoke_bomb/smoke_bomb.tscn").instance()
var audio_stream_player = AudioStreamPlayer3D.new()


func _ready():
	add_to_group("hiding_spots")
	add_child(smoke_bomb)
	
	audio_stream_player.unit_db = -20


func use(body: KinematicBody):
	user = body
	user.visible = false


func on_frob():
	emit_signal("frobbed")
	
	if discovered:
		return
	
	if user == null and Events.seeking:
		Sounds.play_wrong()
		Events.emit_signal("player_guessed_wrong")
	elif user:
		Events.emit_signal("hider_found")
		discovered = true
		smoke_bomb.restart()
		smoke_bomb.emitting = true
		yield(get_tree().create_timer(1), "timeout")
		user.Find()
		user.visible = true
		queue_free()
