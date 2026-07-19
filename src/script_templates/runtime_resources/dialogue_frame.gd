extends Resource
class_name DialogueFrame

@export var dialogue_graph:DialogueGraph

@export var current_node_index:int
@export var starting_node_index:int

var connection_map:Dictionary[Vector2i,Vector2i] = {}
var graph_map:Dictionary[int,BaseDialogueNode] = {}

func _init(graph:DialogueGraph=null) -> void:
	dialogue_graph = graph

#region graph_mapping
func build_maps()->void:
	parse_connections()
	parse_map()

func clear_maps()->void:
	connection_map.clear()
	graph_map.clear()
	starting_node_index = -1

func parse_connections()->void:
	connection_map = DialogueGraphParser.parse_connections(dialogue_graph.connections)

func parse_map()->void:
	var reuslt:GraphParseResult = DialogueGraphParser.parse_graph(dialogue_graph.dialogs)
	graph_map = reuslt.graph
	starting_node_index = reuslt.starting_node_id
#endregion
