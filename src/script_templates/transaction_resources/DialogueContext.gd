extends Resource
class_name DialogueContext

var dialog_box_interface:DialogueTextBoxInterface
var options_interface:DialogueOptionsInterface
var event_interface:DialogueEventInterface
var variable_interface:DialogueVariableInterface


func _clear()->void:
	dialog_box_interface.clear()
