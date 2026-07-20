extends BaseDialogueNode
class_name DialogueConditionNode

@export_multiline() var conditon:String = ""

var result:Variant

@warning_ignore("unused_parameter")
func _enter(context:DialogueContext)->void:
	result = context.expression_interface.evaluate(conditon)

@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	result = null

@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	if result:
		return create_result(transaction_results.ADVANCE,0)
	return create_result(transaction_results.ADVANCE,1)
