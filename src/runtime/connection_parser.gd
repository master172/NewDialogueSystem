extends Node
class_name DialogueConnectionParser

static func parse_connections(connections:Array[DialogueConnection])->Dictionary[Vector2i,Vector2i]:
	var returning_dict:Dictionary[Vector2i,Vector2i] = {}
	for i:DialogueConnection in connections:
		returning_dict[Vector2i(i.from_id,i.from_port)] = Vector2i(i.to_id,i.to_port)
	return returning_dict
