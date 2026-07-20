extends BaseDialogueNode
class_name DialogueEventNode

@export var event_name:String
@export var arguments:Dictionary[String,Variant]

func _enter(context:DialogueContext)->void:
	var argument_list:Array[Variant] = build_argument_list(arguments,context)
	context.event_interface.broadcast(TextParser.parse(event_name,context),argument_list)

func build_argument_list(args:Dictionary[String,Variant],context:DialogueContext)->Array[Variant]:
	var returning_list:Array[Variant] = []
	
	for i:String in args.keys():
		var value:Variant = args[i]
		if value is String:
			returning_list.append(TextParser.parse(value,context))
		else:
			returning_list.append(value)
	
	return returning_list
	
@warning_ignore("unused_parameter")
func _exit(context:DialogueContext)->void:
	pass


@warning_ignore("unused_parameter")
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	return create_result(transaction_results.ADVANCE)
