extends Resource
class_name DialogueContext

var dialog_box_interface:DialogueBox
var options_interface:OptionsInterface




func _clear()->void:
	dialog_box_interface.clear()
