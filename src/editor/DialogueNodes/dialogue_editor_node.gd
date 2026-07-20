@abstract extends GraphNode
class_name DialogueEditorNode

@abstract func seralize()->BaseDialogueNode

func get_connections(name_to_index:Dictionary[StringName,int],connection_map:Array[Dictionary])->Array[DialogueConnection]:
	var connection:DialogueConnection = DialogueConnection.new()
	connection.from_id = name_to_index[self.name]
	connection.from_port = 0
	for i:Dictionary in connection_map:
		if i["from_node"] == self.name:
			connection.to_id = name_to_index[i["to_node"]]
			connection.to_port = i["to_port"]
			return [connection]
	return [connection]
