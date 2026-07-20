extends Control
class_name DialogueEditorOption

@export var option_text: LineEdit
@export var visible_condition: CodeEdit
@export var disabled_condition: CodeEdit

func serialize()->DialogueOptionResource:
	var option:DialogueOptionResource = DialogueOptionResource.new()
	option.text = option_text.text
	option.disabled_condtion = disabled_condition.text
	option.visible_condition = visible_condition.text
	
	return option
	
func _on_remove_pressed() -> void:
	queue_free()
