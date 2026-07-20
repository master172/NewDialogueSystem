extends DialogueEditorNode

@export var code_edit: CodeEdit

func seralize()->BaseDialogueNode:
	var condition_node:DialogueConditionNode = DialogueConditionNode.new()
	condition_node.conditon = code_edit.text
	return condition_node
