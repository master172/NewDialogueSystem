extends DialogueEditorNode

@export var text_edit: TextEdit

func seralize()->BaseDialogueNode:
	var dialogue_node:DialogueTextNode = DialogueTextNode.new()
	dialogue_node.text = text_edit.text
	return dialogue_node
