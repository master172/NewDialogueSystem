extends BaseDialogueNode
class_name DialogueOptionsNode

var _is_finished:bool = false
var _selected_option:int = -1

#TODO instead of passing plain text pass resources that can hold stuff like disabled,
#icons etc
@export var options:Array[DialogueOptionResource] = []

var _visible_options:PackedInt32Array = []

func _enter(context:DialogueContext)->void:
	if not context.options_interface.option_selected.is_connected(option_selected):
		context.options_interface.option_selected.connect(option_selected)
	
	context.options_interface.display_options(_build_options(options,context))

func _build_options(given_options:Array[DialogueOptionResource],context:DialogueContext)->Array[UIOptionResource]:
	_visible_options.clear()
	var resulting_options:Array[UIOptionResource]
	for i:int in given_options.size():
		if not given_options[i].visible_condition.is_empty() and not context.expression_interface.evaluate(given_options[i].visible_condition):
			continue
		resulting_options.append(create_option_resource(given_options[i],context))
		_visible_options.append(i)
	
	return resulting_options

func create_option_resource(option:DialogueOptionResource,context:DialogueContext)->UIOptionResource:
	var returning_option:UIOptionResource = UIOptionResource.new()
	returning_option.text = VariableParser.replace_symbols(option.text,context.variable_interface)
	if not option.disabled_condtion.is_empty():
		returning_option.disabled = context.expression_interface.evaluate(option.disabled_condtion)
	else:
		returning_option.disabled = false
	return returning_option

func _exit(context:DialogueContext)->void:
	if context.options_interface.option_selected.is_connected(option_selected):
		context.options_interface.option_selected.disconnect(option_selected)
	
	context.options_interface.stop_processing()
	_selected_option = -1
	_is_finished = false
	_visible_options.clear()
	
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	if _is_finished:
		return create_result(transaction_results.ADVANCE,_visible_options[_selected_option])
		
	return create_result(transaction_results.RUNNING)

func option_selected(num:int)->void:
	_selected_option = num
	_is_finished = true
