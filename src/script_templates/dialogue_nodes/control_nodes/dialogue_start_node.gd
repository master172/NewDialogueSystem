extends BaseDialogueNode
class_name DialogueStartNode

@warning_ignore("unused_parameter")
func _enter(context:DialogueContext)->void:
	pass

@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	pass

@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	print("starting")
	return create_result(transaction_results.ADVANCE)
