extends Control
class_name DialogueRuntime

enum STATES{
	INACTIVE,
	ACTIVE
}

var current_state:STATES = STATES.INACTIVE

@export var current_dialogue_graph:DialogueGraph

var dialogue_grpah_stack:Array[DialogueFrame] = []

var current_dialogue_node_id:int

var connection_map:Dictionary[Vector2i,Vector2i] = {
	
}
var graph_map:Dictionary[int,BaseDialogueNode] = {
	
}

var starting_node_index:int

var dialogue_context:DialogueContext = DialogueContext.new()

func append_to_dialogue_stack(frame:DialogueFrame)->void:
	dialogue_grpah_stack.append(frame)

func remove_from_dialogue_stack()->void:
	dialogue_grpah_stack.pop_back()

func set_maps(dialogue_graph:DialogueGraph)->void:
	parse_connections(dialogue_graph)
	parse_map(dialogue_graph)

func clear_maps()->void:
	connection_map.clear()
	graph_map.clear()
	starting_node_index = -1

func parse_connections(dialogue_graph:DialogueGraph)->void:
	connection_map = DialogueGraphParser.parse_connections(dialogue_graph.connections)

func parse_map(dialogue_graph:DialogueGraph)->void:
	var reuslt:GraphParseResult = DialogueGraphParser.parse_graph(dialogue_graph.dialogs)
	graph_map = reuslt.graph
	starting_node_index = reuslt.starting_node_id
	
func start_dialog(dialogue_graph:DialogueGraph)->void:
	set_maps(dialogue_graph)
	current_dialogue_graph = dialogue_graph
	current_state = STATES.ACTIVE
	
	current_dialogue_node_id = starting_node_index
	
	graph_map[starting_node_index]._enter(dialogue_context)

func end_dialog()->void:
	clear_maps()
	current_dialogue_graph = null
	current_state = STATES.INACTIVE
	
	current_dialogue_node_id = -1

func _physics_process(delta: float) -> void:
	if current_state == STATES.INACTIVE:
		return
	
	if not current_dialogue_graph:
		push_error("dialogue state active but no dialogue assigned")
		return
	
	if starting_node_index == -1:
		push_error("no valid start point in dialogue")
		return
	
	var result:DialogueNodeUpdateResult
	result = graph_map[current_dialogue_node_id]._update(dialogue_context)

	match result.result_type:
		BaseDialogueNode.transaction_results.END:
			end_dialog()
		BaseDialogueNode.transaction_results.SUCCESS:
			graph_map[current_dialogue_node_id]._exit(dialogue_context)
			var next_node_map:Vector2i = connection_map[Vector2i(result.node_id,result.port_id)]
			current_dialogue_node_id = next_node_map.x
			graph_map[current_dialogue_node_id]._enter(dialogue_context)
	
	
	
