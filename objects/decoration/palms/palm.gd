extends StaticBody


func _ready():
	rotation_degrees.y = deg2rad(randi() % 360 + 1)
