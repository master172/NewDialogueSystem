extends BaseDialogueNode
class_name DialogueOptionsNode

var _is_finished:bool = false
var _selected_option:int = -1

@export var options:PackedStringArray = []

func _enter(context:DialogueContext)->void:
	if not context.options_interface.option_selected.is_connected(option_selected):
		context.options_interface.option_selected.connect(option_selected)
	
	context.options_interface.display_options(options)

func _exit(context:DialogueContext)->void:
	if context.options_interface.option_selected.is_connected(option_selected):
		context.options_interface.option_selected.disconnect(option_selected)
	
	context.options_interface.stop_processing()
	_selected_option = -1
	_is_finished = false

func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	if _is_finished:
		return create_result(transaction_results.ADVANCE,_selected_option)
		
	return create_result(transaction_results.RUNNING)

func option_selected(num:int)->void:
	_selected_option = num
	_is_finished = true
