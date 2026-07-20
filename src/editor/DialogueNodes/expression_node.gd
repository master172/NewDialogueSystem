extends DialogueEditorNode
@export var code_edit: CodeEdit

func seralize()->BaseDialogueNode:
	var expression_node:DialogueExpressionNode = DialogueExpressionNode.new()
	expression_node.expression = code_edit.text
	return expression_node
