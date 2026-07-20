extends DialogueEditorNode

@export var option: PackedScene

var options:Array[DialogueEditorOption]=[]

var next_id:int = 1
var free_ids:Array[int]

func get_current_id()->int:
	if not free_ids.is_empty():
		return free_ids.pop_back()
	
	var id:int = next_id
	next_id += 1
	return id

func free_id(id:int)->void:
	free_ids.push_back(id)
	
func _on_add_option_button_pressed() -> void:
	var new_child:DialogueEditorOption = option.instantiate()
	add_child(new_child,true)
	var id:int = get_current_id()

	set_slot(
		id,
		false,
		0,
		Color.WHITE,
		true,
		0,
		Color.WHITE,
		)
	new_child.assigned_option = id
	options.append(new_child)
	new_child.tree_exiting.connect(deallocate_id.bind(new_child))

func deallocate_id(node:DialogueEditorOption)->void:
	free_ids.push_back(node.assigned_option)
	options.erase(node)
	
func seralize()->BaseDialogueNode:
	var option_node:DialogueOptionsNode = DialogueOptionsNode.new()
	for i:DialogueEditorOption in options:
		option_node.options.append(i.serialize())
	
	return option_node

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
