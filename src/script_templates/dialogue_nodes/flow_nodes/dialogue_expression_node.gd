extends BaseDialogueNode
class_name DialogueExpressionNode

@export_multiline() var expression:String = ""

@warning_ignore("unused_parameter")
func _enter(context:DialogueContext)->void:
	context.expression_interface.evaluate(expression)

@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	pass

@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	return create_result(transaction_results.ADVANCE)
