extends GraphEdit

@export var _end_node: PackedScene
@export var _start_node: PackedScene

var node_to_index:Dictionary[StringName,int]
var next_id:int = 0
var free_ids:Array[int] = []

func _ready() -> void:
	_prepare()

var current_graph:DialogueGraph

#TODO a lot of ux improvemnts making sure output ports can only have a single connection
#copy paste duplicate and cut, alongside frames and right click addition

func _prepare()->void:
	var start_node:GraphNode = _start_node.instantiate()
	start_node.position_offset = Vector2(20,200)
	var end_node:GraphNode = _end_node.instantiate()
	end_node.position_offset = Vector2(600,200)
	add_child(start_node)
	allocate_id(start_node.name)
	add_child(end_node)
	allocate_id(end_node.name)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node,from_port,to_node,to_port)

func add_new_node(node_type:PackedScene)->void:
	var new_node:GraphNode = node_type.instantiate()
	var center:Vector2 = scroll_offset + (size/2.0) / zoom
	new_node.position_offset  = center
	add_child(new_node,true)
	allocate_id(new_node.name)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node,from_port,to_node,to_port)


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for i:StringName in nodes:
		var child:GraphNode = get_node_or_null(NodePath(i))
		deallocate_id(i)
		delete_graph_node(child)

func delete_graph_node(node:GraphNode)->void:
	for connection:Dictionary in get_connection_list():
		if connection.from_node == node.name or connection.to_node == node.name:
			disconnect_node(
				connection.from_node,
				connection.from_port,
				connection.to_node,
				connection.to_port,
			)
	
	node.queue_free()

func get_current_id()->int:
	if not free_ids.is_empty():
		return free_ids.pop_back()
	
	var id:int = next_id
	next_id += 1
	return id

func free_id(id:int)->void:
	free_ids.push_back(id)

func allocate_id(node_name:StringName)->void:
	node_to_index[node_name] = get_current_id()

func deallocate_id(node_name:StringName)->void:
	if not node_to_index.has(node_name):
		push_error("error trying to deallocate non existent id")
		return
	free_id(node_to_index[node_name])
	node_to_index.erase(node_name)
	
func _on_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	for connection:Dictionary in get_connection_list():
		if connection.from_node == from_node and connection.from_port == from_port:
			disconnect_node(
				connection.from_node,
				connection.from_port,
				connection.to_node,
				connection.to_port
			)
			return

func _serialize()->DialogueGraph:
	var connection_list:Array[Dictionary] = get_connection_list()
	var graph:DialogueGraph = DialogueGraph.new()
	
	for i:Node in get_children():
		if not i is DialogueEditorNode:
			continue
		i = i as DialogueEditorNode
		var node:BaseDialogueNode = i.seralize()
		node.id = node_to_index[i.name]
		graph.dialogs.append(node)
		graph.connections.append_array(i.get_connections(node_to_index,connection_list))
	
	
	return graph
	
func _on_tool_bar_seralize(save_location:String) -> void:
	ResourceSaver.save(_serialize(),save_location)
