extends Node
class_name DialogueGraphParser

static func parse_connections(connections:Array[DialogueConnection])->Dictionary[Vector2i,Vector2i]:
	var returning_dict:Dictionary[Vector2i,Vector2i] = {}
	for i:DialogueConnection in connections:
		returning_dict[Vector2i(i.from_id,i.from_port)] = Vector2i(i.to_id,i.to_port)
	return returning_dict

static func parse_graph(graph:Array[BaseDialogueNode])->GraphParseResult:
	var starting_id:int = -1
	var returning_dict:Dictionary[int,BaseDialogueNode] = {}
	
	for i:BaseDialogueNode in graph:
		if returning_dict.has(i.id):
			push_error("error id already exsists in graph")
			continue
		if i is DialogueStartNode:
			starting_id = i.id
		returning_dict[i.id] = i
	
	var result:GraphParseResult = GraphParseResult.new()
	result.starting_node_id = starting_id
	result.graph = returning_dict
	
	return result
