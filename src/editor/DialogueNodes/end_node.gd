extends DialogueEditorNode

func seralize()->BaseDialogueNode:
	var end_node:DialogueEndNode = DialogueEndNode.new()
	return end_node

func get_connections(name_to_index:Dictionary[StringName,int],connection_map:Array[Dictionary])->Array[DialogueConnection]:
	return []
