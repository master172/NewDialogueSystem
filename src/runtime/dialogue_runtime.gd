extends Control
class_name DialogueRuntime

signal dialogue_finished(dialogue:DialogueGraph)
signal dialogue_sequence_finished

@export_group("public_interfaces")
@export var event_bus: EventBus

@export_group("interfaces")
@export var dialog_box: DialogueTextBoxInterface
@export var options_container: DialogueOptionsInterface
@export var event_interface: DialogueEventInterface
@export var variable_interface: DialogueVariableInterface
@export var expression_interface: DialogueExpressionInterface

enum STATES{
	INACTIVE,
	ACTIVE
}

var current_state:STATES = STATES.INACTIVE:
	set(value):
		current_state = value
		process_visibility()

@export_group("dialogue")
@export var dialogue_grpah_stack:Array[DialogueFrame] = []

var dialogue_context:DialogueContext = DialogueContext.new()

func _ready() -> void:
	current_state = STATES.INACTIVE
	
	dialogue_context.dialog_box_interface = dialog_box
	dialogue_context.options_interface = options_container
	dialogue_context.event_interface = event_interface
	dialogue_context.variable_interface = variable_interface
	dialogue_context.expression_interface = expression_interface
	
func process_visibility()->void:
	if current_state == STATES.INACTIVE: visible = false
	else: visible = true

#region dialogue_stack
func append_to_dialogue_stack(frame:DialogueFrame)->void:
	dialogue_grpah_stack.append(frame)

func remove_from_dialogue_stack()->void:
	dialogue_grpah_stack.pop_back()

func get_current_dialogue_graph()->DialogueFrame:
	return dialogue_grpah_stack.back()
#endregion



#region dailog_control
func start_dialog(dialogue_graph:DialogueGraph)->void:
	var frame:DialogueFrame = DialogueFrame.new(dialogue_graph)
	frame.build_maps()
	frame.current_node_index = frame.starting_node_index
	dialogue_grpah_stack.append(frame)
	
	current_state = STATES.ACTIVE
	
	frame.graph_map[frame.starting_node_index]._enter(dialogue_context)

func end_dialog()->void:
	var frame:DialogueFrame = get_current_dialogue_graph()
	frame.graph_map[frame.current_node_index]._exit(dialogue_context)
	
	var temp_dialog_graph:DialogueGraph = get_current_dialogue_graph().dialogue_graph
	dialogue_finished.emit(temp_dialog_graph)
	temp_dialog_graph = null
	
	remove_from_dialogue_stack()
	
	if dialogue_grpah_stack.is_empty():
		finish_runtime()
		

func finish_runtime()->void:
	current_state = STATES.INACTIVE
	dialogue_context._clear()
	dialogue_sequence_finished.emit()
	
#endregion

func _physics_process(delta: float) -> void:
	if current_state == STATES.INACTIVE:
		return
	
	var frame:DialogueFrame = get_current_dialogue_graph()
	
	if not frame.dialogue_graph:
		push_error("dialogue state active but no dialogue assigned")
		return
	
	
	if frame.starting_node_index == -1:
		push_error("no valid start point in dialogue")
		return
	
	
	var result:DialogueNodeUpdateResult
	result = frame.graph_map[frame.current_node_index]._update(dialogue_context)
	
	match result.result_type:
		BaseDialogueNode.transaction_results.FAILURE:
			push_error("default result type recived, node not configured")
		BaseDialogueNode.transaction_results.END:
			end_dialog()
		BaseDialogueNode.transaction_results.ADVANCE:
			frame.graph_map[frame.current_node_index]._exit(dialogue_context)
			var next_node_map:Vector2i = frame.connection_map[Vector2i(frame.current_node_index,result.port_id)]
			frame.current_node_index = next_node_map.x
			frame.graph_map[frame.current_node_index]._enter(dialogue_context)
		BaseDialogueNode.transaction_results.RUNNING:
			pass
		
	
	
