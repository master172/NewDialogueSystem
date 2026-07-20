extends DialogueEditorNode

@export var code_edit: CodeEdit

func seralize()->BaseDialogueNode:
	var condition_node:DialogueConditionNode = DialogueConditionNode.new()
	condition_node.conditon = code_edit.text
	return condition_node

func get_connections(name_to_index:Dictionary[StringName,int],connection_map:Array[Dictionary])->Array[DialogueConnection]:
	var connections:Array[DialogueConnection] = []
	for i:Dictionary in connection_map:
		if i["from_node"] == self.name:
			var connection:DialogueConnection = DialogueConnection.new()
			connection.from_id = name_to_index[self.name]
			connection.from_port = i["from_port"]
			connection.to_id = name_to_index[i["to_node"]]
			connection.to_port = i["to_port"]
			connections.append(connection)
	
	return connections
