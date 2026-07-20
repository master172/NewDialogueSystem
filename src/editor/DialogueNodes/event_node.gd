extends DialogueEditorNode

@export var argument: PackedScene

@export var line_edit: LineEdit
@export var arg_path: LineEdit

func seralize()->BaseDialogueNode:
	var event_node:DialogueEventNode = DialogueEventNode.new()
	event_node.event_name = line_edit.text
	
	if arg_path.text != "":
		var arg_list:DialogueArgumentList = ResourceLoader.load(arg_path.text)
		if not arg_list:
			push_error("failed to load arg list")
		event_node.arguments = arg_list.get_args()
	return event_node


func _on_add_argument_pressed() -> void:
	add_child(argument.instantiate(),true)
