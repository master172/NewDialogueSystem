extends BaseDialogueNode
class_name DialogueEventNode

@export var event_name:String
@export var arguements:Array[Variant]

func _enter(context:DialogueContext)->void:
	context.event_interface.brodcast(event_name,arguements)


@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	pass


@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	return create_result(transaction_results.ADVANCE)
