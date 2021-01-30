extends HidingSpot
class_name LaughingBarrel


export var laughing := false setget set_laughing
export var disabled := false

var laughs = [
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_0.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_1.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_2.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_3.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_4.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_5.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_6.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_7.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_8.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_9.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_10.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_11.wav"),
	preload("res://objects/hiding_spots/barrel/assets/final/sounds/laugh_12.wav"),
];

onready var audio = $AudioStreamPlayer3D

func _ready():
	self.laughing = laughing
	laugh()


func set_laughing(value: bool):
	if disabled:
		laughing = false
		return
	
	laughing = value
	if laughing:
		$MeshInstance.set("material/0", load("res://objects/hiding_spots/barrel/assets/final/laughing_barrel.material"))
		laugh()
	else:
		$MeshInstance.set("material/0", load("res://objects/hiding_spots/barrel/assets/final/barrel.material"))
		if audio:
			audio.stop()


func laugh():
	while laughing:
		audio.stream = laughs[randi() % laughs.size()]
		audio.play()
		yield(audio, "finished")


func on_frob():
	.on_frob()
	
	if user == null:
		self.laughing = not laughing
