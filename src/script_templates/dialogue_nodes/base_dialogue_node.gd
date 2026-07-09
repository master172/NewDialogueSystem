@abstract extends Resource
class_name BaseDialogueNode

enum transaction_results{
	END,
	ADVANCE,
	RUNNING,
	FAILURE
}

func create_result(type_of_result:transaction_results,port:int=0)->DialogueNodeUpdateResult:
	var result:DialogueNodeUpdateResult = DialogueNodeUpdateResult.new()
	result.result_type = type_of_result
	result.node_id = id
	result.port_id = port
	return result

@export var id:int

@abstract func _enter(context:DialogueContext)->void

@abstract func _exit(context:DialogueContext)->void

@abstract func _update(context:DialogueContext)->DialogueNodeUpdateResult
