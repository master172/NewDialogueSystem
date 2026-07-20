extends GraphEdit

@export var _end_node: PackedScene
@export var _start_node: PackedScene


func _ready() -> void:
	_prepare()

func _prepare()->void:
	var start_node:GraphNode = _start_node.instantiate()
	start_node.position_offset = Vector2(20,200)
	var end_node:GraphNode = _end_node.instantiate()
	end_node.position_offset = Vector2(600,200)
	add_child(start_node)
	add_child(end_node)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node,from_port,to_node,to_port)

func add_new_node(node_type:PackedScene)->void:
	var new_node:GraphNode = node_type.instantiate()
	var center:Vector2 = scroll_offset + (size/2.0) / zoom
	new_node.position_offset  = center
	add_child(new_node,true)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node,from_port,to_node,to_port)


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for i:StringName in nodes:
		var child:GraphNode = get_node_or_null(NodePath(i))
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
