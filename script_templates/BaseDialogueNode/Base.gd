extends BaseDialogueNode

@warning_ignore("unused_parameter")
func _enter(context:DialogueContext)->void:
	pass

@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	pass

@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	return create_result(transaction_results.FAILURE)
