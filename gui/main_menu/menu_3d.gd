extends Spatial
class_name Menu3D


const SELECTED_MATERIAL = preload("res://gui/main_menu/assets/final/selected.material")
const UNSELECTED_MATERIAL = preload("res://gui/main_menu/assets/final/unselected.material")

var selected_index: int = 0 setget set_selected_index
var current := false


func set_selected_index(value: int) -> void:
	selected_index = value
	
	for i in get_child_count():
		var child: MeshInstance = get_child(i)
		if i == selected_index:
			child.material_override = SELECTED_MATERIAL
		else:
			child.material_override = UNSELECTED_MATERIAL


func _ready():
	self.selected_index = 0
