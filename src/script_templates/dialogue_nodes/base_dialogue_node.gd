@abstract extends Resource
class_name BaseDialogueNode

enum transaction_results{
	END,
	ADVANCE,
	RUNNING,
	FAILURE,
	CALL,
	RETURN,
}

func create_result(type_of_result:transaction_results,port:int=0)->DialogueNodeUpdateResult:
	var result:DialogueNodeUpdateResult = DialogueNodeUpdateResult.new()
	result.result_type = type_of_result
	result.port_id = port
	return result

@export var id:int

@abstract func _enter(context:DialogueContext)->void

@abstract func _exit(context:DialogueContext)->void

@abstract func _update(context:DialogueContext)->DialogueNodeUpdateResult
