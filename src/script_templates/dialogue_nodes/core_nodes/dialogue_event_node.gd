extends BaseDialogueNode
class_name DialogueEventNode

@export var event_name:String
@export var arguements:Dictionary[String,Variant]

func _enter(context:DialogueContext)->void:
	var arguement_list:Array[Variant] = build_arguement_list(arguements,context)
	context.event_interface.brodcast(event_name,arguement_list)

func build_arguement_list(args:Dictionary[String,Variant],context:DialogueContext)->Array[Variant]:
	var returning_list:Array[Variant] = []
	
	for i:String in args.keys():
		var result:Variant = VariableParser.replace_symbols(args[i],context.variable_interface)
		returning_list.append(result)
	
	return returning_list
	
@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	pass


@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	return create_result(transaction_results.ADVANCE)
