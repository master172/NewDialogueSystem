extends BaseDialogueNode
class_name DialogueEventNode

@export var event_name:String
@export var arguements:Dictionary[String,Variant]

func _enter(context:DialogueContext)->void:
	var arguement_list:Array[Variant] = build_arguement_list(arguements,context)
	context.event_interface.broadcast(VariableParser.replace_symbols(event_name,context.variable_interface),arguement_list)

func build_arguement_list(args:Dictionary[String,Variant],context:DialogueContext)->Array[Variant]:
	var returning_list:Array[Variant] = []
	
	for i:String in args.keys():
		var result:Variant = VariableParser.replace_symbols(args[i],context.variable_interface)
		if args[i] is String:
			returning_list.append(result)
		else:
			returning_list.append(args[i])
	
	return returning_list
	
@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	pass


@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	return create_result(transaction_results.ADVANCE)
