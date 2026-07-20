extends DialogueEditorNode

@export var option: PackedScene

var options:Array[DialogueEditorOption]=[]
func _on_add_option_button_pressed() -> void:
	var new_child:DialogueEditorOption = option.instantiate()
	add_child(new_child,true)
	set_slot(
		get_child_count()-1,
		false,
		0,
		Color.WHITE,
		true,
		0,
		Color.WHITE,
		)
	options.append(new_child)

func seralize()->BaseDialogueNode:
	var option_node:DialogueOptionsNode = DialogueOptionsNode.new()
	for i:DialogueEditorOption in options:
		option_node.options.append(i.serialize())
	
	return option_node
