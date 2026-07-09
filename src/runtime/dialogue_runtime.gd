extends Control
class_name DialogueRuntime

@export var current_dialogue_graph:DialogueGraph

var dialogue_grpah_stack:Array[DialogueFrame] = []

var current_dialogue_node_id:int
var current_dialogue_node:BaseDialogueNode

var connection_map:Dictionary[Vector2i,Vector2i] = {
	
}
func append_to_dialogue_stack(frame:DialogueFrame)->void:
	dialogue_grpah_stack.append(frame)

func remove_from_dialogue_stack()->void:
	dialogue_grpah_stack.pop_back()


func _ready() -> void:
	connection_map = DialogueConnectionParser.parse_connections(current_dialogue_graph.connections)
