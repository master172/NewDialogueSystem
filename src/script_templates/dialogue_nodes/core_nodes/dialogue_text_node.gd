extends BaseDialogueNode
class_name DialogueTextNode

@export_multiline var text:String = ""

var is_finished:bool = false

func _enter(context:DialogueContext)->void:
	if not context.dialog_box_interface.advance_signal.is_connected(advance_signal_recieved):
		context.dialog_box_interface.advance_signal.connect(advance_signal_recieved)
	
	var parsed_text:String = TextParser.parse(text,context)
	context.dialog_box_interface.display_dialog(parsed_text)
	
	
func _exit(context:DialogueContext)->void:
	if context.dialog_box_interface.advance_signal.is_connected(advance_signal_recieved):
		context.dialog_box_interface.advance_signal.disconnect(advance_signal_recieved)
	
	is_finished = false
	
func _update(context:DialogueContext)->DialogueNodeUpdateResult:
	if is_finished:
		return create_result(transaction_results.ADVANCE)
	
	return create_result(transaction_results.RUNNING)

func advance_signal_recieved()->void:
	is_finished = true
